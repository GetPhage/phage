require 'forwardable'

require 'dnssd'

require 'pp'

# fetch /description.xml and use it to learn about the device
module Phage
  class Scan
    class Mdns
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection

      def initialize
        @collection = []

        results = `avahi-browse -a -r -t -v -k`
        if results.nil?
          abort 'Failed to run avahi-browse'
        end

        mdns = Phage::Scan::Mdns.parse_avahi results
        mdns.each do |m|
          if m[:address] && !m[:address].empty?
            device = Device.where("'#{m[:address]}' = ANY(ipv4)").first
            m[:device] = device
          else
            puts 'missing address!'
            pp m
          end

          @collection.push m
        end
      end

      def self.parse_avahi(str)
        item = { lines: [] }
        all_items = []
        str.each_line do |line|
          line.chomp!

          if line == ': All for now'
            return all_items
          end

          next if line.match /^Failed to resolve service/
          next if line.match /^\+/

          if line.match(/^=/)
            unless item.empty?
              all_items.push item
            end

            m = line.match /\s+(\S+)\s+([\w\.]+)$/
            item = { service: m[1], domain: m[2], lines: [ line ] }

            next
          end

          item[:lines].push line

          m = line.match /^\s+hostname = \[(\S+)\]$/
          if m
            item[:hostname] = m[1]
            next
          end

          m = line.match /^\s+address = \[(\S+)\]$/
          if m
            item[:address] = m[1]
            next
          end

          m = line.match /^\s+port = \[(\d+)\]$/
          if m
            item[:port] = m[1]
            next
          end

          m = line.match /^\s+txt = \[(.+)\]$/
          if m
            item[:txt] = m[1]
            next
          end

          m = line.match /^\s+txt = \[\]/
          if m
            item[:txt] = ''
            next
         end

          puts "unknown line: #{line}"
        end
      end

      def diff(start = Time.now, complete = Time.now)
        scan = ::Scan.create scan_type: 'mdns', start: start, end: complete

        @collection.each do |mdns|
          pp mdns
          next if mdns[:service].nil? || mdns[:service].empty?

          service_protocol = mdns[:service].split

          next unless ::Mdn.where(hostname: mdns[:hostname], service: service_protocol[0], protocol: service_protocol[1]).empty?

          m = ::Mdn.create hostname: mdns[:hostname],
                          service: service_protocol[0],
                          protocol: service_protocol[1],
                          port: mdns[:port],
                          txt: mdns[:txt],
                          device: mdns[:device]

          ScanDiff.create extra: { mdns: m }, device: mdns[:device], status: :add, scan: scan, kind: 'mdns'
        end

        ::Mdn.all.each do |mdns|
          next unless @collection.select { |item| item[:hostname] == mdns[:hostname] && item[:service] == "#{mdns[:service]}.#{mdns[:protocol]}" }.empty?

          ScanDiff.create extra: { mdns: mdns }, device: mdns[:device], status: :remove, scan: scan, kind: 'mdns'
        end

      end

    end
  end
end

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

#        results = `avahi-browse -a -r -t -v -k`

        results = `avahi-browse -v -r -p -k -t _http._tcp`
        results += `avahi-browse -v -r -p -k -t _https._tcp`
        results += `avahi-browse -v -r -p -k -t _ssh._tcp`
        results += `avahi-browse -v -r -p -k -t _daap._tcp`
        results += `avahi-browse -v -r -p -k -t _nfs._tcp`
        results += `avahi-browse -v -r -p -k -t _printer._tcp`
        results += `avahi-browse -v -r -p -k -t _workstation._tcp`
        if results.nil?
          abort 'Failed to run avahi-browse'
        end

        mdns = Phage::Scan::Mdns.parse_avahi results
        pp mdns
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

          next if line.match /^\+/
          next if !line.match /^\=/
          
#          m = line.match /\=;\S+;IPv(?<ip_version>[4|6]);(?<service_name>\S+);(?<service>\S+);(?<domain>\S+);(?<hostname>\S+);(?<ip_address>\S+);(<?<port>\d+)/
          m = line.match /\=;\S+;IPv(?<ip_version>[4|6]);(?<service_name>\S+);(?<service>\S+);(?<domain>\S+);(?<hostname>\S+);(?<ip_address>\S+);(?<port>\S+);(?<txt>.*)/

          if m
            hash = Hash[ m.names.zip(m.captures) ]
            hash.symbolize_keys!

            unless hash[:txt].empty?
              hash[:txt] = hash[:txt].split(/"\s+"/ )
            end

            pp line
            pp hash

            item[:lines].push hash
          else
            puts "unknown line #{line}"
          end
        end

        all_items
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

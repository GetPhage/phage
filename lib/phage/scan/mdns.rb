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

        results = ''
        %w(airport http https homekit daap nfs mediaremotetv spotify-connect androidtvremote workstation printer printer._sub._http airplay raop privet uscans uscan ipp ippusb ipps scanner pdl-datastream ptp airplay raop ssh ftp telnet afpovertcp smb rfb adisk googlecast).each do |service|
          str = `avahi-browse -v -r -p -k -t _#{service}._tcp`
          if str
            results += str
          else
            puts "backticks returned nil!!!"
          end
        end
        results += `avahi-browse -v -r -p -k -t _sleep-proxy._udp`
      
        if results == ''
          abort 'Failed to run avahi-browse'
        end

        mdns = Phage::Scan::Mdns.parse_avahi results
#        pp mdns
        mdns.each do |m|
          if m[:ip_address] && !m[:ip_address].empty?
            m[:device] = Device.where("'#{m[:ip_address]}' = ANY(ipv4)").first
          else
            puts 'missing address!'
#            pp m
          end

          @collection.push m
        end
      end

      def self.parse_avahi(str)
        all_items = []
        str.each_line do |line|
          line.chomp!

          # sometimes we get illegal UTF-8 characters; get rid of them
          line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

          if line.match /^\+/
            next
          end

          next if !line.match /^\=/
          
#          m = line.match /\=;\S+;IPv(?<ip_version>[4|6]);(?<service_name>\S+);(?<service>\S+);(?<domain>\S+);(?<hostname>\S+);(?<ip_address>\S+);(<?<port>\d+)/
          m = line.match /\=;\S+;IPv(?<ip_version>[4|6]);(?<service_name>\S+);(?<service>\S+);(?<domain>\S+);(?<hostname>\S+);(?<ip_address>\S+);(?<port>\S+);(?<txt>.*)/

          if m
            hash = Hash[ m.names.zip(m.captures) ]
            hash.symbolize_keys!

            unless hash[:txt].empty?
              hash[:txt] = hash[:txt].split(/"\s+"/ )
            end

#            pp line
#            pp hash

            all_items.push hash
          else
            puts "unknown line #{line}"
          end
        end

        all_items
      end

      def diff(start = Time.now, complete = Time.now)
        scan = ::Scan.create scan_type: 'mdns', start: start, end: complete

        puts "Mdns:diff has #{@collection.length} records"

        @collection.each do |mdns|
          pp mdns

          next unless ::Mdn.where(hostname: mdns[:hostname], service: mdns[:service], protocol: 'tcp').empty?

          m = ::Mdn.create hostname: mdns[:hostname],
                          service: mdns[:service],
                          protocol: 'tcp',
                          port: mdns[:port],
                          txt: mdns[:txt],
                          device: mdns[:device]

          ScanDiff.create extra: { mdns: m }, device: mdns[:device], status: :add, scan: scan, kind: 'mdns'
        end

        ::Mdn.all.each do |mdns|
          next unless @collection.select { |item| item[:hostname] == mdns[:hostname] && item[:service] == "#{mdns[:service]}" }.empty?

          ScanDiff.create extra: { mdns: mdns }, device: mdns[:device], status: :remove, scan: scan, kind: 'mdns'
        end

      end

    end
  end
end

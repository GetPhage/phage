require 'forwardable'
require 'pp'

module Phage
  class Scan
    class Ports
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection
      
      def initialize
        @collection = {}

        Device.all.each do |device|
          @collection[device.id] = Phage::Scan::Ports.scan_host(device[:ipv4].first)
        end
      end

      def self.scan_host(host)
        puts "port scan host #{host}"
        output = `nmap -oX - -n -PN -p- --host-timeout 3m #{host}`
        results = Hash.from_xml output
        pp results
        if results.empty?
          puts "fail on #{host}"
          return { tcpv4: [], udpv4: [] }
        end

        ports = {}
        begin
          ports[:tcpv4] = results["nmaprun"]["host"]["ports"]["port"].select { |item| item["protocol"] == "tcp" }.pluck("portid").map! { |item| item.to_i }
          ports[:udpv4] = results["nmaprun"]["host"]["ports"]["port"].select { |item| item["protocol"] == "udp" }.pluck("portid").map! { |item| item.to_i }
        rescue
          puts "fail on #{host}"
          return { tcpv4: [], udpv4: [] }
        end

        ports
      end

      def self.scan_network()
      end

      def diff(start = Time.now, complete = Time.now)
        scan = Scan.create scan_type: "ports", start: start, complete: complete

        @collection.each do |key, item|
          d = Device.find key
          removed_ports = d[:tcpv4] - item[:tcpv4]
          unless removed_ports.empty?
            ScanDiff.create device: d,
                            scan: scan,
                            status: :remove,
                            kind: "ports",
                            extra: { ports: removed_ports }
          end

          new_ports = item[:tcpv4] - d[:tcpv4]
          unless new_ports.empty?
            ScanDiff.create device: d,
                            scan: scan,
                            status: :add,
                            kind: "ports",
                            extra: { ports: new_ports }
          end

          unless new_ports.empty? && removed_ports.empty?
            d.tcpv4 = item[:tcpv4]
            d.save
          end
        end
      end
    end
  end
end

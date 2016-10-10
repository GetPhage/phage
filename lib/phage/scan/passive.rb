require 'forwardable'
require 'pp'

module Phage
  class Scan
    class Passive
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection
      
      def initialize
        @collection = []

        system "ping -b -c 1 -W 1 255.255.255.255 >/dev/null 2>&1 &"
        system "ping -b -c 1 -W 1 10.0.1.255 >/dev/null 2>&1 &"
        Device.find_each do |dev|
          system "ping -c 1 -W 1 #{dev[:ipv4]} >/dev/null 2>&1 &"
        end

        (1..254).each do |i|
          system "ping -c 1 -W 1 10.0.1.#{i} >/dev/null 2>&1 &"
        end

        lines = `/usr/sbin/arp -a`.split "\n"
        lines.each do |line|
          match = line.match /\((\d+\.\d+\.\d+\.\d+)\) at (\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}) \[ether\] on (\S+)/
          next unless match

          @collection.push({ ipv4: match[1], mac_address: match[2], interface: match[3] })
        end
      end

      def diff(start, complete)
        scan = ::Scan.create scan_type: "passive", start: start, end: complete

        @collection.each do |item|
          pp item
          
          d = Device.find_by mac_address: item[:mac_address]
          pp d

          if d
            unless d[:ipv4].include?(item[:ipv4])
              puts "different ip"
              puts d[:ipv4], item[:ipv4]

              d[:ipv4].push item[:ipv4]
              d.save

              ScanDiff.create( { ipv4: item[:ipv4], device: d, status: :change, scan: scan, kind: "passive" } )
            end
          end

          unless d
            puts "create device"
            d = Device.create mac_address: item[:mac_address], ipv4: [ item[:ipv4] ], kind: '', last_seen: Time.now
            pp d

            ScanDiff.create( { mac_address: item[:mac_address], ipv4: item[:ipv4], device: d, status: :change, scan: scan, kind: "passive" } )
          end
        end

      end


    end
  end
end

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
          match = line.match /(\S+) \((\d+\.\d+\.\d+\.\d+)\) at (\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}) \[ether\] on (\S+)/
          next unless match

          @collection.push({ ipv4: match[2], mac_address: match[3], interface: match[4], name: match[1] == '?' ? '' : match[1] })
        end
      end

      def diff(start, complete)
        scan = ::Scan.create scan_type: "passive", start: start, end: complete

        @collection.each do |item|
          pp item
          
          d = Device.find_by mac_address: item[:mac_address]
          pp d

          if d
            unless d.active?
              d.active = true
              d.save

              ScanDiff.create( { extras: { active: true }, device: d, status: :change, scan: scan, kind: 'passive' } )
            end

            unless d.has_ipv4?(item[:ipv4])
              puts "different ip"
              puts d[:ipv4], item[:ipv4]

              d[:ipv4].push item[:ipv4]
              d.save

              ScanDiff.create( { ipv4: item[:ipv4], device: d, status: :change, scan: scan, kind: "passive" } )
            end

            unless item[:name] != '' && d.has_name?(item[:name])
              puts "different name"
              puts d[:name], item[:name]

              d[:name] ||= []
              d[:name].push item[:name]
              d.save

              ScanDiff.create( { name: item[:name], device: d, status: :add, scan: scan, kind: "passive" } )
            end
          else
            puts "create device"
            d = Device.create mac_address: item[:mac_address], ipv4: [ item[:ipv4] ], kind: '', last_seen: Time.now
            pp d

            ScanDiff.create( { mac_address: item[:mac_address], ipv4: item[:ipv4], device: d, status: :add, scan: scan, kind: "passive" } )
          end
        end

        Device.all.each do |device|
          if @collection.select { |item| item[:mac_address] == device[:mac_address] }.empty?
            device.active = false
            device.save
            ScanDiff.create( { mac_address: device[:mac_address], device: device, status: :remove, scan: scan, kind: "passive" } )
          end
        end

      end


    end
  end
end

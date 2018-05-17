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
          system "ping -c 1 -W 1 #{dev[:ipv4][0].to_s} >/dev/null 2>&1 &"
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
          d = Device.find_or_create_by(mac_address: item[:mac_address]) do |d|
            puts "create device"
            d.update_attributes(mac_address: item[:mac_address], ipv4: [ item[:ipv4] ], kind: '', last_seen: Time.now, active: true)
            d.save
            pp d

            sd = ScanDiff.create( { mac_address: item[:mac_address], ipv4: item[:ipv4], device: d, status: :add, scan: scan, kind: "passive" } )
            History.create message: "New host #{d.friendly_name} - #{item[:ipv4]} - #{item[:mac_address]}", scan_diff: sd, device: d

#            SendNewDeviceEmailJob.perform_later(d.id)
            next
          end
          
          sd = ScanDiff.create( { extra: { active: true }, device: d, status: :up, scan: scan, kind: 'passive' } ) unless d.active?

          unless d.update_attributes(last_seen: Time.now, active: true)
            puts "update_attributes on device #{d.id} #{d.friendly_name} fails!"
            puts d.errors.full_messages
            puts Device.errors.full_messages
          end

          unless d.has_ipv4?(item[:ipv4])
            puts "different ip"
            puts d[:ipv4], item[:ipv4]

            d[:ipv4].push item[:ipv4]
            d.save

            sd = ScanDiff.create( { ipv4: item[:ipv4], device: d, status: :change, scan: scan, kind: "passive" } )
            History.create message: "IP address changed on #{d.friendly_name} to #{item[:ipv4]}", scan_diff: sd, device: d
          end

          if item[:name] != '' && !d.has_name?(item[:name]) then
            puts "different name"
            puts "'#{d[:name]}', '#{item[:name]}'"

            d[:name] ||= []
            old_name = d[:name].first
            old_name ||= "not set"

            d[:name].push item[:name]
            d.save

            sd = ScanDiff.create( { extra: { active: false }, name: item[:name], device: d, status: :down, scan: scan, kind: "passive" } )
            History.create message: "Name on device #{d.id} -  #{old_name} changed to #{item[:name]}", scan_diff: sd, device: d
          end
        end

        Device.all.each do |device|
          if @collection.select { |item| item[:mac_address] == device[:mac_address] }.empty?
            next if device.active && device.last_seen < Time.now - 10.seconds

            device.update_attributes(active: false)
            sd = ScanDiff.create( { extra: { active: false }, device: device, status: :down, scan: scan, kind: "passive" } )
          end
        end
      end
    end
  end
end

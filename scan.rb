require 'pp'

$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'active_record'
require 'models'
require 'scan/passive'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'jarvis',
  username: 'postgres'
)

passive_scanner = Scan::Passive.new

scan = Scan.create scan_type: 'Scan::Passive', start: Time.now, end: Time.now

passive_scanner.each do |item|
  next unless item[:interface] == 'eth1'

  device = Device.find_by mac_address: item[:mac_address]

#    pp device
#    pp device.public_methods.sort

  unless device
    device = Device.create mac_address: item[:mac_address], ipv4: item[:ipv4], last_seen: Time.now
    diff = ScanDiff.create scan: scan, kind: 'New Device', data: { ipv4: item[:ipv4] }, status: :added
    pp device, diff
  else
    if device[:ipv4] != item[:ipv4]
      diff = ScanDiff.create scan: scan, kind: 'IP address change', data: { ipv4: item[:ipv4]  }, status: :changed
    end
  end
end

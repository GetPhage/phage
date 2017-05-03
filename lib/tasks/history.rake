namespace :history do
  desc 'Generate history entries'
  task :generate => [:environment] do
    ScanDiff.where(status: :add).each do |sd|
#      History.create message: "Added new device #{sd.device.friendly_name}", scan_diff: sd, user: sd.device.network.user
      if sd.kind == 'mdns'
        History.create message: "Added new mDNS name #{sd.extra['mdns']['hostname']}"
        next
      end

      History.create message: "Added new device #{sd.device.friendly_name}", scan_diff: sd
    end
  end

  desc 'Remove all history entries'
  task :clean => [:environment] do
    History.delete_all
  end
end

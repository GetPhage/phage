require 'phage/scan/upnp'

namespace :upnp do
  task :devices => [:environment] do
    Upnp.all.each do |u|
      next if u.device

      dev = Phage::Scan::Upnp::get_device u
      u.device = dev
      u.save
    end
  end

  task :names => [:environment] do
    Upnp.all.each do |u|
      next unless u.device

      info = Phage::Scan::Upnp::probe_device(u)
      next unless info

      puts info["root"]["device"]["friendlyName"]

      u.device[:name].push info["root"]["device"]["friendlyName"]
      u.device.save
    end
  end
end

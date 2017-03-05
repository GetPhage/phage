require 'phage/scan/upnp'

namespace :upnp do
  desc "Associate devices with UPNP info"
  task :devices => [:environment] do
    Upnp.all.each do |u|
      next if u.device

      dev = Phage::Scan::Upnp::get_device u
      u.device = dev
      u.save
    end
  end

  desc "Update UPNP-related device metadata"
  task :names => [:environment] do
    Upnp.all.each do |u|
      next unless u.device

      info = Phage::Scan::Upnp::probe_device(u)
      next unless info

      puts info["root"]["device"]["friendlyName"]

      m = Manufacturer.where(name: info["root"]["device"]["manufacturer"]).first_or_create(name: info["root"]["device"]["manufacturer"])
      p = Product.where(manufacturer: m, name: info["root"]["device"]["modelName"]).first_or_create manufacturer: m,
                                                                                                    name: info["root"]["device"]["modelName"]

      u.device.product = p

      unless u.device[:name].include? info["root"]["device"]["friendlyName"]
        u.device[:name].push info["root"]["device"]["friendlyName"]
      end
      u.device[:firmware_version] = info["root"]["device"]["firmwareVersion"]
      u.device[:serial_number] = info["root"]["device"]["serialNumber"]
      u.device[:upc] = info["root"]["device"]["UPC"]
      u.device[:model_description] = info["root"]["device"]["modelDescription"]
      u.device[:model_shortname] = info["root"]["device"]["modelName"]
      u.device[:model_number] = info["root"]["device"]["modelNumber"]
      u.device.save

    end
  end

  desc "Perform UPNP scan"
  task :scan => [:environment] do
    UpnpScanJob.perform_later
  end

  desc "Perform UPNP scan immediately (not in background)"
  task :scan => [:environment] do
    UpnpScanJob.perform_now
  end
end

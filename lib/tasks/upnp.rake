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

      m = Manufacturer.first_or_create(name: info["root"]["device"]["manufacturer"])

#      u.device.manufacturer_id = m.id;
      u.device[:name].push info["root"]["device"]["friendlyName"]
      u.device[:firmware_version] = info["root"]["device"]["firmwareVersion"]
      u.device[:serial_number] = info["root"]["device"]["serialNumber"]
      u.device[:upc] = info["root"]["device"]["UPC"]
      u.device[:model_description] = info["root"]["device"]["modelDescription"]
      u.device[:model_shortname] = info["root"]["device"]["modelName"]
      u.device[:model_number] = info["root"]["device"]["modelNumber"]
      u.device.save

    end
  end
end

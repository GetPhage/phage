require 'import_oui'

namespace :oui do
  desc "Import OUIs from oui.txt"
  task :import => [:environment] do
    oui = OUI.new "./oui.txt"
    oui.each do |item|
      Oui.find_or_create_by item
    end
  end

  desc "Associate OUIs with Devices"
  task :associate => [:environment] do
    Device.all.each do |device|
      puts device.mac_address
      prefix = device.mac_address[0, 8].gsub(/:/, '').upcase
      puts prefix
      device.oui = Oui.find_by prefix: prefix
      device.save
    end
  end
end

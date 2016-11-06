require 'net/http'
require 'uri'

require 'import_oui'

namespace :oui do
  OUI_DOWNLOAD_FILENAME='tmp/oui.txt'

  desc 'Download updated oui.txt file'
  task :download do
    uri = URI.parse 'http://standards-oui.ieee.org/oui.txt'
    results = Net::HTTP.get uri

    # force encoding because we were getting encoding errors
    File.open(  OUI_DOWNLOAD_FILENAME='tmp/oui.txt', 'w') { |f| f.write results.force_encoding('UTF-8') }
  end

  desc 'Import OUIs from oui.txt'
  task :import_file => [:environment] do
    oui = OUI.new   OUI_DOWNLOAD_FILENAME='tmp/oui.txt'
    oui.each do |item|
      Oui.find_or_create_by item
    end
  end

  desc 'Associate OUIs with Devices'
  task :associate => [:environment] do
    Device.all.each do |device|
      prefix = device.mac_address[0, 8].gsub(/:/, '').upcase
      device.oui = Oui.find_by prefix: prefix
      device.save
    end
  end

  desc 'Download and import OUIs from IEEE'
  task :import => [:download, :import_file, :associate]
end

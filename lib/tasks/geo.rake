require 'net/http'
require 'uri'

namespace :geo do
  GEO_DOWNLOAD_URL='http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip'
  GEO_DOWNLOAD_FILENAME='tmp/geo.zip'
  GEO_DOWNLOADED_LOCATIONS='tmp/GeoLite2-Country-CSV_20171003/GeoLite2-Country-Locations-en.csv'
  GEO_DOWNLOADED_IPS='tmp/GeoLite2-Country-CSV_20171003/GeoLite2-Country-Blocks-IPv4.csv'

  desc 'Download updated oui.txt file'
  task :download do
    uri = URI.parse GEO_DOWNLOAD_URL
    results = Net::HTTP.get uri

    # force encoding because we were getting encoding errors
    File.open(GEO_DOWNLOAD_FILENAME, 'wb') { |f| f.write results }
    system 'cd tmp; unzip geo.zip'
  end

  desc 'Import geo information from downloaded files'
  task :import_locations => [:environment] do
    CSV.foreach(GEO_DOWNLOADED_LOCATIONS) do |csv|
      geoname_id = csv[0]
      next if geoname_id == 'geoname_id'

      continent_name = csv[3]
      country_code = csv[4]
      country_name = csv[5]

      unless GeoLocation.find_by(geoname_id: geoname_id)
        GeoLocation.create geoname_id: geoname_id,
                           continent: continent_name,
                           country: country_name || '',
                           country_code: country_code || ''
      end
    end
  end

  desc 'Import geo information from downloaded files'
  task :import_ips => [:environment] do
    CSV.foreach(GEO_DOWNLOADED_IPS) do |csv|
      network = csv[0]
      next if network == 'network'

      geoname_id = csv[1]

      location = GeoLocation.find_by geoname_id: geoname_id
      unless GeoIp.find_by(ipaddr: IPAddr.new(network))
        GeoIp.create geo_location: location,
                     ipaddr: IPAddr.new(network)
      end
    end
  end

  desc 'Download and import geo IP information'
  task :import => [:download, :import_locations, :import_ips]

  desc 'Report on geolocation data'
  task :report => [ :environment ] do
    puts "Locations: #{GeoLocation.all.count}"
    puts "Known IP networks: #{GeoIp.all.count}"
  end
end

require "net/http"
require "uri"

namespace :services do
  SERVICES_DOWNLOAD_FILENAME='tmp/services.csv'

  desc "Download service names"
  task :download do
    uri = URI.parse 'http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv'
    results = Net::HTTP.get uri
    File.open(SERVICES_DOWNLOAD_FILENAME, 'w') { |file| file.write results.force_encoding('UTF-8') }
  end

  desc "Import service names from file"
  task :import_file => [:environment] do
    CSV.parse(SERVICES_DOWNLOAD_FILENAME) do |csv|
      name = csv[0]
      port_number = csv[1]
      next if name.nil? || name.empty? || port_number.nil? || port_number.empty?

      Service.where(name: name, port_number: port_number.to_i).first_or_create name: name,
                                                                               port_number: port_number.to_i,
                                                                               protocol: csv[2] || '',
                                                                               description: csv[3] || '',
                                                                               reference: csv[8] || ''
    end
  end

  desc 'Download and import service names'
  task :import => [:download, :import_file]
end

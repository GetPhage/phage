require "net/http"
require "uri"

namespace :ports do
  desc "Import service names"
  task :import => [:environment] do
    uri = URI.parse 'http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv'

    results = Net::HTTP.get uri
    CSV.parse results do |csv|
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
end

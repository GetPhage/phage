require 'net/http'

# fetch /description.xml and use it to learn about the device
class Scan
  class UPNP
    def initialize(host)
      @host = host
    end
    def perform
      results = Net::HTTP.get(host, '/description.xml')
      
    end
  end
end

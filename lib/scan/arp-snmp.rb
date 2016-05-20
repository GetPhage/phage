require 'snmp'

require 'pp'

# https://github.com/hallidave/ruby-snmp
module Scan
  class ArpSNMP
    include Enumerable

    attr :collection

    def initialize(host)
      @host = host
      @collection = []
    end

    def perform
      SNMP::Manager.open(host: @host) do |manager|
        manager.walk('ipNetToMediaPhysAddress.3') do |row|
          @collection.push { ipv4: "",
                             mac_address: row[:value]
          }
        end
      end
    end

    protected
    def find_interface(ip_address)
      # search for ipAdEntIfIndex.10.0.1.1, returns the index of the interface
    end

    def extract_ipv4(str)
      str.match /(\d+\.\d+\.\d+\.\d+)^/
      if match
        match[1]
      end
    end
    
    def ethernet_to_s(value)
      value.map { |b| sprintf(", 0x%02X",b) }.join(':')
    # show hex
    # line = a.map { |b| sprintf(", 0x%02X",b) }.join
    # http://stackoverflow.com/questions/8350171/convert-string-to-hexadecimal-in-ruby
    end
  end
end

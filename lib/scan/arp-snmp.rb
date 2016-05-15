require 'snmp'

require 'pp'

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
  end
end

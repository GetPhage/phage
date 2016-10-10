require 'active_record'
require './lib/models'

pp

class Scan
  class Local
    def initialize(interface)
      @interface = interface
    end

    MAC_REGEX = /^(\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2})?$/
    
    def perform
      ifconfig_string = `/sbin/ifconfig #{@interface}`
      output = {}

      # parser from https://gist.github.com/granolocks/2471244
      ifconfig_string.gsub!("RX ", "RX_")
      ifconfig_string.gsub!("TX ", "TX_")
      ifconfig_string.gsub!(" (", "_(")
      raw_array = ifconfig_string.split(' ').grep(/:/)
      output["HWaddr"] = raw_array.grep(MAC_REGEX)[0]
      output["ipv6_addr"] = ifconfig_string.split("\n").grep(/inet6/)[0]
      output["ipv6_addr"] = output["ipv6_addr"].split[2] unless output["ipv6_addr"] == nil
      hash_array = raw_array.map {|e| e.split(':') }
      hash_array.reject!{|e| e.length != 2 }
      hash_array.inject(output) do |output, element|
        output[element[0]] = element[1]
        output
      end

      ActiveRecord::Base.establish_connection(
        adapter: 'postgresql',
        database: 'jarvis',
        username: 'postgres'
      )

      n = Network.find_or_create(id: 1)
      n.device_name = interface
      n.ip_v4 = output['addr']
      n.device_type = output['encap'].downcase
      n.mac_address = output['HWaddr']
      n.ip_v6 = output['ipv6_addr']
      n.netmask = output['Mask']
      n.save

      pp n
    end
  end
end

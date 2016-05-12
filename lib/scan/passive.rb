#require 'arp'

require 'forwardable'

class Scan
  class Passive
    include Enumerable

    extend Forwardable
    def_delegators :collection, :each, :<<, :size

    attr_accessor :collection
    
    def initialize
      @collection = []
    
      lines = `/usr/sbin/arp -a`.split "\n"
      lines.each do |line|
        match = line.match /\((\d+\.\d+\.\d+\.\d+)\) at (\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}) \[ether\] on (\S+)/
        next unless match

        @collection.push({ ipv4: match[1], mac_address: match[2], interface: match[3] })
      end
    end
  end
end


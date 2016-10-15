require 'forwardable'

module Phage
  class Scan
    class Ports
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection
      
      def initialize
        @collection = []
      end

      def scan_host(host)
        `nmap -n -PN -sT -sU -p- 10.0.1.177`
      end

      def scan_network()
      end
    end
  end
end

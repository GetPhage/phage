require 'forwardable'

require 'dnssd'

require 'pp'

# fetch /description.xml and use it to learn about the device
module Phage
  class Scan
    class Mdns
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection

      def initialize
        @collection = []

        DNSSD.browse '' do |reply|
          pp reply
        end
      end
    end
  end
end

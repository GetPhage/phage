require 'forwardable'

require 'easy_upnp'

require 'net/http'
require 'pp'

module Phage
  class Scan
    class Upnp
      include Enumerable

      extend Forwardable
      def_delegators :collection, :each, :<<, :size

      attr_accessor :collection

      def initialize
        start = Time.now

        @collection = []

        searcher = EasyUpnp::SsdpSearcher.new

        all_devices = []
        res = searcher.search 'ssdp:all'
        all_devices += res if res

        res = searcher.search 'urn:Belkin:service:basicevent:1'
        all_devices += res if res

        puts "found #{all_devices.length} UPNP devices"
        all_devices.each do |dev|
          begin
            info = dev.description

            device = Phage::Scan::Upnp::get_device(dev)

            ::Upnp.first_or_create(device: device,
                                   description: description.pretty_inspect,
                                   services: dev.all_services)
          rescue
          end
        end

        complete = Time.now

        # ScanDiff.create scan_type: 'upnp', start: start, end: complete

        all_devices.length
      end

      def self.get_device(dev)
        begin
          m = dev[:location].match /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
          return unless m

          Device.where("'#{m[1]}' = ANY(ipv4)").first
        rescue
          return nil
        end
      end

    end
  end
end

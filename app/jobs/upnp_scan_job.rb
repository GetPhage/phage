require 'phage/scan/upnp'
require 'pp'

class UpnpScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      start = Time.now
      scanner = Phage::Scan::Upnp.new
      complete = Time.now

#      puts "SCANNER"
#      pp scanner
#      scanner.diff(start, complete)
    rescue => exception
      puts "UpnpScanJob"
      puts exception.backtrace
      raise
    end
  end
end

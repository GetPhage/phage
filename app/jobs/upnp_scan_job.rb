require 'phage/scan/upnp'
require 'pp'

class UpnpScanJob < ApplicationJob
  queue_as "com.romkey.phage.backburner-jobs"

  def perform(*args)
    start = Time.now
    scanner = Phage::Scan::Upnp.new
    complete = Time.now

    puts "SCANNER"
    pp scanner
#    scanner.diff(start, complete)
  end
end

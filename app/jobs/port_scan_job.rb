require 'phage/scan/ports'
require 'pp'

class PortScanJob < ApplicationJob
  queue_as "com.romkey.phage.backburner-jobs"

  def perform(*args)
    start = Time.now
    scanner = Phage::Scan::Ports.new
    complete = Time.now

    puts "SCANNER"
    pp scanner
    scanner.diff(start, complete)  end
end

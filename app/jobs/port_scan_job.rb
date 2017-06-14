require 'phage/scan/ports'
require 'pp'

class PortScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      start = Time.now
      scanner = Phage::Scan::Ports.new
      complete = Time.now

      puts "PortScanJob"
      pp scanner
      scanner.diff(start, complete)  end
    rescue => exception
      puts "PortScanJob"
      puts exception.backtrace
      raise
    end
end

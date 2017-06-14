require 'phage/scan/mdns'

class MdnsScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      start = Time.now
      scanner = Phage::Scan::Mdns.new
      complete = Time.now

      scanner.diff(start, complete)
    rescue => exception
      puts "MdnsScanJob"
      puts exception.backtrace
      raise
    end
  end
end

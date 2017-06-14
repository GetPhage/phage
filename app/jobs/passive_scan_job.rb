require 'phage/scan/passive'

class PassiveScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      start = Time.now
      scanner = Phage::Scan::Passive.new
      complete = Time.now

      scanner.diff(start, complete)
    rescue => exception
      puts "PassiveScanJob"
      puts exception.backtrace
      raise
    end
  end
end

require 'phage/scan/mdns'

class MdnsScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    start = Time.now
    scanner = Phage::Scan::Mdns.new
    complete = Time.now

    scanner.diff(start, complete)
  end
end

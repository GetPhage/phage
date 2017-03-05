require 'phage/scan/mdns'

class MdnsScanJob < ApplicationJob
  queue_as "com.romkey.phage.backburner-jobs"

  def perform(*args)
    start = Time.now
    scanner = Phage::Scan::Mdns.new
    complete = Time.now

    scanner.diff(start, complete)
  end
end

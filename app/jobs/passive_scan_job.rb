require 'phage/scan/passive'

class PassiveScanJob < ApplicationJob
  queue_as "com.romkey.phage.backburner-jobs"

  def perform(*args)
    start = Time.now
    scanner = Phage::Scan::Passive.new
    complete = Time.now

    scanner.diff(start, complete)
  end
end

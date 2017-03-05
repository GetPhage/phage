require 'phage/scan/passive'

namespace :passive do
  desc "Perform passive scan"
  task :scan => [:environment] do
    PassiveScanJob.perform_later
  end

  desc "Perform passive scan immediately (not in job runner)"
  task :scan_now => [:environment] do
    PassiveScanJob.perform_now
  end
end

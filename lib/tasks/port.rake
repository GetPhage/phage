namespace :port do
  desc "Perform port scan"
  task :scan => [:environment] do
    PortScanJob.perform_later
  end

  desc "Perform port scan immediately (not in job runner)"
  task :scan_now => [:environment] do
    PortScanJob.perform_now
  end
end

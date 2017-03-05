namespace :mdns do
  desc "Perform mdns scan"
  task :scan => [:environment] do
    MdnsScanJob.perform_later
  end

  desc "Perform mdns scan immediately (not in job runner)"
  task :scan_now => [:environment] do
    MdnsScanJob.perform_now
  end

  desc "Download mDNS services list"
  task :download_services do
    MDNS_DOWNLOAD_URL = "http://www.dns-sd.org/servicetypes.html"
  end

  task :import_services_file => [:environment] do
  end

  task :import_services => [:download_services, :import_services_file]
end

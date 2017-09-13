dev_null = Logger.new("/dev/null")
Rails.logger = dev_null
ActiveRecord::Base.logger = dev_null

namespace :pcap do
  desc 'Import pcap files'
  task :import => [:environment] do
    filename = 'packets.json'
    puts filename
    PartialFlow::import(filename)
  end

  desc 'Remove pcap entries'
  task :clean => [:environment] do
    PartialFlow.delete_all
  end
end

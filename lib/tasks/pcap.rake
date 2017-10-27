dev_null = Logger.new("/dev/null")
Rails.logger = dev_null
ActiveRecord::Base.logger = dev_null

namespace :pcap do
  desc 'Import pcap files'
  task :import_file => [:environment] do
    filename = 'packets.json'
    data = File.read('packets.json')
    PartialFlow::import(data)
  end

  desc 'Import pcap from STDIN'
  task :import_stdin => [:environment] do
    data = STDIN.read
    PartialFlow::import(data)
  end

  desc 'Remove pcap entries'
  task :clean => [:environment] do
    PartialFlow.delete_all
  end
end

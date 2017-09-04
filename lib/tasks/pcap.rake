namespace :pcap do
  desc 'Import pcap files'
  task :import => [:environment] do
    PartialFlow.import('./data/flow-dump')
  end

  desc 'Remove pcap entries'
  task :clean => [:environment] do
    PartialFlow.delete_all
  end
end

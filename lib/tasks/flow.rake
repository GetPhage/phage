namespace :flow do
  desc 'Identify flows'
  task :identify => [:environment] do
      Flow.identify
  end

  desc 'Remove flow entries'
  task :clean => [:environment] do
    Flow.delete_all
  end
end

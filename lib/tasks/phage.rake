namespace :phage do
  desc 'Bootstrap Phage'
  task :bootstrap do
    Rake::Task['cve:import'].invoke
    Rake::Task['oui:import'].invoke
    Rake::Task['services:import'].invoke
  end
end

# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "phage"
set :repo_url, "git@github.com:GetPhage/phage.git"
set :deploy_to, '/home/phage/phage'

set :rbenv_ruby, "2.3.1"

set :bugsnag_api_key, ENV['BUGSNAG_API_KEY']

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

append :linked_files, '.env'

task :restart_app do
  on roles(:web) do
    puts "monit a"
    execute '/home/phage/phage/current/scripts/puma.sh restart'
  end
end

task :restart_workers do
  on roles(:web) do
    puts "monit w"
    execute '/home/phage/phage/current/scripts/backburner.sh restart'
  end
end

after 'deploy:finishing', 'restart_app'
after 'deploy:finishing', 'restart_workers'


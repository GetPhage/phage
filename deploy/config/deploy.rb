# config valid only for current version of Capistrano
lock "3.11.0"

set :application, "phage"
set :repo_url, "git@github.com:GetPhage/phage.git"
set :deploy_to, '/home/phage/phage'

#set :rbenv_ruby, "2.5.1"

#append :linked_files, 'config/master.key'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", '.bundle'


set :bugsnag_api_key, ENV['BUGSNAG_API_KEY']

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

append :linked_files, '.env'

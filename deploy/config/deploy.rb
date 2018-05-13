# config valid only for current version of Capistrano
lock "3.10.2"

set :application, "phage"
set :repo_url, "git@github.com:GetPhage/phage.git"
set :deploy_to, '/home/phage/phage'

#set :rbenv_ruby, "2.5.1"

set :bugsnag_api_key, ENV['BUGSNAG_API_KEY']

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

append :linked_files, '.env'

#!/usr/bin/env puma

directory '/home/phage/phage/current'
rackup "/home/phage/phage/current/config.ru"
environment 'production'

tag ''

pidfile "/home/phage/phage/shared/tmp/pids/puma.pid"
state_path "/home/phage/phage/shared/tmp/pids/puma.state"
stdout_redirect '/home/phage/phage/shared/log/puma_access.log', '/home/phage/phage/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///home/phage/phage/shared/tmp/sockets/puma.sock'

workers 0





prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end



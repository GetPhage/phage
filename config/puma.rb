#!/usr/bin/env puma

# some ideas taken from https://gist.github.com/sudara/8653130
directory '/home/phage/phage/current'
rackup "/home/phage/phage/current/config.ru"
environment 'production'

tag ''

pidfile "/home/phage/phage/shared/tmp/pids/puma.pid"
state_path "/home/phage/phage/shared/tmp/puma.state"
stdout_redirect '/home/phage/phage/shared/log/puma_access.log', '/home/phage/phage/shared/log/puma_error.log', true

threads 0,16
bind 'unix:///home/phage/phage/shared/tmp/sockets/puma.sock'

workers 4

prune_bundler

on_worker_boot do |worker_index|

  # write worker pid
  File.open("tmp/puma_worker_#{worker_index}.pid", "w") { |f| f.puts Process.pid }

  # reconnect to redis
  Redis.current.client.reconnect

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/phage/phage/current/Gemfile"
end

plugin :tmp_restart

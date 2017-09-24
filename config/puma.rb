#!/usr/bin/env puma

# some ideas taken from https://gist.github.com/sudara/8653130

if ENV["RACK_ENV"] == "production"
  HOME_DIR = '/home/phage/phage'
  CURRENT_DIR = "#{HOME_DIR}/current"
  SHARED_DIR = "#{HOME_DIR}/shared"

  WORKER_COUNT=4
  environment 'production'
  bind "unix://#{SHARED_DIR}/tmp/sockets/puma.sock"

  preload_app!
#  ActiveSupport.on_load(:active_record) do
#    ActiveRecord::Base.establish_connection
#  end
#  before_fork do
#    ActiveRecord::Base.connection_pool.disconnect!
#  end
else
  HOME_DIR = '/home/phage/phage'
  CURRENT_DIR = HOME_DIR
  SHARED_DIR = "/home/phage/shared"

  WORKER_COUNT=0
  environment 'development'
  port 3000
end

workers WORKER_COUNT

directory CURRENT_DIR
rackup "#{CURRENT_DIR}/config.ru"

tag ''

pidfile "#{SHARED_DIR}/tmp/pids/puma.pid"
state_path "#{SHARED_DIR}/tmp/puma.state"
stdout_redirect "#{SHARED_DIR}/log/puma_access.log", "#{SHARED_DIR}/log/puma_error.log", true

threads 0,16

on_worker_boot do |worker_index|
  # write worker pid
  File.open("#{SHARED_DIR}/tmp/pids/puma_worker_#{worker_index}.pid", "w") { |f| f.puts Process.pid }

  # reconnect to redis
#  Redis.current.client.reconnect

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "#{CURRENT_DIR}/Gemfile"
end

plugin :tmp_restart

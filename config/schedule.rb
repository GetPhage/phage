job_type :rbenv_rake, %Q{export PATH=/home/phage/.rbenv/shims:/home/phage/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)";  cd :path && :environment_variable=:environment :bundle_command rake :task --silent :output }

every 1.minutes do
  rbenv_rake "passive:scan"
end

every 15.minutes do
  rbenv_rake "mdns:scan"
end

#every 5.minutes do
#  rake "upnp:scan"
#end

#every 120.minutes do
#  rake "port:scan"
#end

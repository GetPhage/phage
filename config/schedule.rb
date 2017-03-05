every 1.minutes do
  rake "passive:scan"
end

every 5.minutes do
  rake "upnp:scan"
end

every 120.minutes do
  rake "port:scan"
end

json.extract! upnp, :id, :device_id, :st, :usn, :location, :cache_control, :server, :ext, :created_at, :updated_at
json.url upnp_url(upnp, format: :json)
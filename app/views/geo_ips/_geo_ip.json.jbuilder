json.extract! geo_ip, :id, :ipaddr, :geo_location_id, :created_at, :updated_at
json.url geo_ip_url(geo_ip, format: :json)

json.extract! device, :id, :mac_address, :ipv4, :ipv6, :kind, :last_seen, :extra, :created_at, :updated_at
json.url device_url(device, format: :json)
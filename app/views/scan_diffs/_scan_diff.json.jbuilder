json.extract! scan_diff, :id, :scan_id, :device_id, :kind, :status, :extra, :created_at, :updated_at
json.url scan_diff_url(scan_diff, format: :json)
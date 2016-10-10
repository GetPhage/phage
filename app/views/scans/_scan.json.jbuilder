json.extract! scan, :id, :scan_type, :start, :end, :notes, :created_at, :updated_at
json.url scan_url(scan, format: :json)
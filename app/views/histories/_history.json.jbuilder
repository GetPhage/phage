json.extract! history, :id, :message, :scan_diff_id, :created_at, :updated_at
json.url history_url(history, format: :json)
json.extract! cfe, :id, :name, :seq, :status, :desc, :refs, :comments, :created_at, :updated_at
json.url cfe_url(cfe, format: :json)
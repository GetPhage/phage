json.extract! service, :id, :name, :port_number, :protocol, :description, :reference, :created_at, :updated_at
json.url service_url(service, format: :json)
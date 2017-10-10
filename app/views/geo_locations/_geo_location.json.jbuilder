json.extract! geo_location, :id, :geoname_id, :continent, :country, :created_at, :updated_at
json.url geo_location_url(geo_location, format: :json)

class GeoIp < ApplicationRecord
  belongs_to :geo_location, optional: true
end

class Upnp < ApplicationRecord
  belongs_to :device, optional: true
end

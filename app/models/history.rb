class History < ApplicationRecord
  belongs_to :scan_diff
  belongs to :device
  belongs_to :user, optional: true

  scope :per_user, -> (user) { where(user: user) }
end

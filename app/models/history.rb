class History < ApplicationRecord
  belongs_to :scan_diff
  belongs_to :user

  scope :per_user, -> (user) { where(user: user) }
end

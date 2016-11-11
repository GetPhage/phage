class Network < ApplicationRecord
  scope :per_user, -> user { where(user: user) }

  belongs_to :user
end

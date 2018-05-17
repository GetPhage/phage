class History < ApplicationRecord
  belongs_to :scan_diff
  belongs_to :device
  belongs_to :user, optional: true

  scope :per_user, -> (user) { where(user: user) }

  after_create do
    HistoryMailer.with(history: self).activity_email.deliver_later
  end
end

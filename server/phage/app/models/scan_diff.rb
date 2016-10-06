class ScanDiff < ApplicationRecord
  belongs_to :scan
  belongs_to :device

  enum status: [:add, :remove, :change]
end

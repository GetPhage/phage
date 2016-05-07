class Scan < ActiveRecord
  has_many :devices
  has_many :scan_diffs
end

class ScanDiff < ApplicationRecord
  belongs_to :scan
  belongs_to :device

  enum status: [:add, :remove, :change]

  store_accessor :extra, :ipv4, :ipv6, :mac_address, :name
end

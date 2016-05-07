require 'active_record'

class Network < ActiveRecord::Base
  enum device_type: [ :ethernet, :wifi ]

#  mac_address mac_address
#  inet_address my_ipv4
#  inet_address my_ipv6

#  cidr_address netmask
#  inet_address default_gw
end

class Device < ActiveRecord::Base
  has_many :scan
  has_many :scan_diffs
  has_many :software_versions
  has_many :upnp
  has_many :mdns
end

class Scan < ActiveRecord::Base
  has_many :scan_diff
end

class ScanDiff < ActiveRecord::Base
  enum status: [ :added, :removed, :modified ]
#  hstore :data

  belongs_to :scan
  belongs_to :device
end

class SoftwareVersions < ActiveRecord::Base
end

class SoftwareBlacklist < ActiveRecord::Base
end

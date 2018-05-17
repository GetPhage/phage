class Device < ApplicationRecord
  rails_admin do
    edit do
      field :ipv4, :pg_string_array
      field :ipv6, :pg_string_array
      field :name, :pg_string_array
    end
  end

  belongs_to :oui, optional: true
  belongs_to :product, optional: true
  belongs_to :network, optional: true
  has_many :scan_diff, dependent: :destroy
  has_many :history, dependent: :destroy
  has_many :flow
  has_one :upnp

  scope :per_user, -> user { where(network: Network.per_user(user).first) }
  
  after_create do
    HistoryMailer.with(history: self).activity_email.deliver_later
  end

  def add_name(name)
    unless has_name? name
      self.name.push name
    end
  end

  def has_name?(name)
    self.name.include? name
  end

  def friendly_name
    unless self.given_name.empty?
      return self.given_name
    end
    
    unless self.name.empty?
      return self.name.first
    end

    unless self.ipv4.empty?
      return self.ipv4.first
    end

    unless self.ipv6.empty?
      return self.ipv6.first
    end

    self.mac_address.to_s
  end

  def has_ipv4?(ipv4_address)
    self.ipv4.include? ipv4_address
  end

  def has_ipv6?(ipv6_address)
    self.ipv6.include? ipv6_address
  end
end

class Device < ApplicationRecord
  rails_admin do
    edit do
      field :ipv4, :pg_string_array
      field :ipv6, :pg_string_array
      field :name, :pg_string_array
    end
  end

  def has_name?(name)
    self.name.include? name
  end

  def has_ipv4?(ipv4_address)
    self.ipv4.include? ipv4_address
  end

  def has_ipv6?(ipv6_address)
    self.ipv6.include? ipv6_address
  end
end

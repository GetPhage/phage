class Hostname < ApplicationRecord
  def best_name
    rec = names.select { |rec| rec["source"] == 'given' }
    return rec.first["hostname"] if rec.length > 0

    rec = names.select { |rec| rec["source"] == 'sni' }
    return rec.first["hostname"] if rec.length > 0

    rec = names.select { |rec| rec["source"] == 'dns' }
    return rec.first["hostname"] if rec.length > 0
  end
end

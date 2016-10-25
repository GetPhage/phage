Devise.setup do |config|
  # other stuff...

  config.omniauth :slack, "28560322256.70806131683", "0dd8cdb467f34df30d7276114438a4e9" scope: 'identity.basic', team: 'romkey'

  # other stuff...
end

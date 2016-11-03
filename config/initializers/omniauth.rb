Devise.setup do |config|
  # other stuff...

  config.omniauth :slack, ENV['SLACK_APP_ID'], ENV['SLACK_APP_SECRET'], scope: 'identity.basic', team: 'romkey'

  # other stuff...
end

# encoding: utf-8

##
# Backup Generated: backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t backup [-c <path_to_configuration_file>]
#
require 'dotenv'

Backup::Model.new(:backup, 'Description for backup') do
  database SQLite do |db|
    # Path to database
    db.path               = ENV.fetch('DATABASE_PATHNAME')
    # Optional: Use to set the location of this utility
    #   if it cannot be found by name in your $PATH
    db.sqlitedump_utility = "sqlite3"
  end

  compress_with Bzip2 do |compression|
    compression.level = 9
  end

  encrypt_with OpenSSL do |encryption|
    encryption.password      = ENV.fetch('BACKUP_ENCRYPTION_KEY')
    encryption.base64        = true
    encryption.salt          = true
  end

  notify_by Slack do |slack|
    slack.on_success = true
    slack.on_warning = true
    slack.on_failure = true

    # The integration token
    slack.webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
  end

  ##
  # Amazon Simple Storage Service [Storage]
  #
  # Available Regions:
  #
  #  - ap-northeast-1
  #  - ap-southeast-1
  #  - eu-west-1
  #  - us-east-1
  #  - us-west-1
  #
  store_with S3 do |s3|
    s3.access_key_id     = ENV.fetch('S3_ACCESS_KEY_ID')
    s3.secret_access_key = ENV.fetch('S3_SECRET_ACCESS_KEY')
    s3.region            = ENV.fetch('S3_REGION')
    s3.bucket            = ENV.fetch('S3_BUCKET')
    s3.path              = ENV.fetch('S3_BACKUP_PATH')
    s3.keep              = 10
  end
end

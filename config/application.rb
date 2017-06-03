require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Phage
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :backburner
  end
end

Backburner.configure do |config|
  config.beanstalk_url       = ["beanstalk://127.0.0.1", "..."]
  config.tube_namespace      = "com.romkey.phage"
  config.namespace_separator = "."
  config.on_error            = lambda { |e| puts e }
  config.max_job_retries     = 3 # default 0 retries
  config.retry_delay         = 2 # default 5 seconds
  config.retry_delay_proc    = lambda { |min_retry_delay, num_retries| min_retry_delay + (num_retries ** 3) }
  config.default_priority    = 65536
  config.respond_timeout     = 120
  config.default_worker      = Backburner::Workers::Simple
  config.logger              = Logger.new(File.new("/tmp/phage2.log", "w+"))
  config.primary_queue       = "backburner-jobs"
  config.priority_labels     = { :custom => 50, :useless => 1000 }
  config.reserve_timeout     = nil
end

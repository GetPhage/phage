require 'sneakers'

phage_jobs_password = ENV['RABBITMQ_PHAGE_JOBS_PASSWORD']

Sneakers.configure({
  amqp: "amqp://phage_jobs:#{phage_jobs_password}@localhost:5672",
  vhost: 'phage_jobs',
  exchange: 'phage_jobs',
  exchange_type: :direct
                   })

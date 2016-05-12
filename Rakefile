#!/usr/bin/env rake

require 'active_record'
require 'yaml'
require 'sqlite3'
require 'logger'

task default: %w[db:migrate]

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
end

Dir.glob('lib/tasks/*.rake').each { |r| load r}

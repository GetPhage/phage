namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task migrate: :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  desc "Create the database"
  task :create do
    `createdb -U postgres jarvis`
  end

  desc "Drop the database"
  task :drop do
    `dropdb -U postgres jarvis`
  end
end

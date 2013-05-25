$:.unshift File.expand_path('../lib', __FILE__)
require 'ossistant'

OSSISTANT_ENV = ENV['RACK_ENV'] || 'development'

# Setup the environment for the application
task :environment do
  Ossistant.setup_env
end

namespace :db do

  desc "Create the database"
  task(:create => :environment) do
    db_name = Ossistant.env.db_config['database']
    conn = ActiveRecord::Base.connection
    if Ossistant.env.db_config['adapter'] =~ /sqlite/
      require 'pathname'
      path = Pathname.new(db_name)
      file = path.absolute? ? path.to_s : File.join(Ossistant.env.root, path)

      FileUtils.rm(file)
    else
      conn.drop_database(db_name) if conn.respond_to?(:drop_database)
      conn.create_database(db_name) if conn.respond_to?(:drop_database)
    end
    puts "Created empty database for #{OSSISTANT_ENV}"
  end

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
  end
end

$:.unshift File.expand_path('../lib', __FILE__)
require 'ossistant'
require 'rake/testtask'
require 'fileutils'
require 'delayed/tasks'

OSSISTANT_ENV = ENV['RACK_ENV'] || 'development'


desc "Unit Tests"
Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# Setup the environment for the application
task :environment do
  Ossistant.setup_env
end

namespace :db do

  desc "Create the database"
  task(:create => :environment) do
    db_name = Ossistant.env.db_config['database']
    if Ossistant.env.db_config['adapter'] =~ /sqlite/
      require 'pathname'
      path = Pathname.new(db_name)
      file = path.absolute? ? path.to_s : File.join(Ossistant.env.root, path)

      FileUtils.rm(file)
    else
      Ossistant.env.connect_db('database' => 'postgres',
                               'schema_search_path' => 'public')

      ActiveRecord::Base.connection.drop_database(db_name)
      ActiveRecord::Base.connection.create_database(db_name)
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

namespace :jobs do
  desc "Run a delayed job worker quietly"
  task :worksilent => :environment do
    Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'],
                        :max_priority => ENV['MAX_PRIORITY'],
                        :queues => (ENV['QUEUES'] || ENV['QUEUE'] || '').split(','),
                        :quiet => true).start
  end
end


require 'rails/test_help'

class ActiveSupport::TestCase
  Dir.chdir Dir.pwd + '/test/theme' do
    Rails.env = 'test'
    Ecrire::Application.initialize!
  end
  
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Warden::Test::Helpers

  ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
  ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
  ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true

  begin
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
      ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
    end
  rescue ActiveRecord::NoDatabaseError => e
    if @tries == 0
      @tries += 1
      puts 'Database does not exist. Creating...'
      ActiveRecord::Tasks::DatabaseTasks.create_current
      puts 'Database created, migrating now...'
      retry
    else
      raise e
    end
  end

end

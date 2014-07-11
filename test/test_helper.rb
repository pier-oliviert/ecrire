require 'rails/test_help'

class ActiveSupport::TestCase

  Dir.chdir Dir.pwd + '/test/theme' do
    Rails.env = 'test'
    Ecrire::Application.initialize!
  end
  self.fixture_path = "#{Dir.pwd}/test/fixtures"

  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Warden::Test::Helpers

  path = Rails.application.paths['db/migrate'].existent
  migration = ActiveRecord::Migrator.migrations(path).last
  current_version = ActiveRecord::Migrator.get_all_versions.max

  begin
    ActiveRecord::Migrator.migrate(path)
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

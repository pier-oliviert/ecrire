class ActiveSupport::TestCase
  begin
    # ActiveRecord's configuration assignation is done at the same time as the connection is tried
    # If it fails, the configurations aren't set in AR::Base.
    # This is why this is set here
    ActiveRecord::Base.configurations = Rails.application.config.database_configuration

    path = Rails.application.paths['db/migrate'].existent
    ActiveRecord::Migrator.migrations_paths = path
    if ActiveRecord::Migrator.needs_migration?
      ActiveRecord::Migrator.migrate(path)
    end
  rescue ActiveRecord::NoDatabaseError
    puts 'Database does not exist. Creating...'
    ActiveRecord::Tasks::DatabaseTasks.create_current
    puts 'Database created, migrating now...'
    ActiveRecord::Migrator.migrate(path)
    puts "Migration completed."
  ensure
    ActiveRecord::Migration.maintain_test_schema!
    include ActiveRecord::TestFixtures
    self.fixture_path = "#{Dir.pwd}/test/fixtures/"
    fixtures :all
    Post.reset_column_information
  end


end

ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

def create_fixtures(*fixture_set_names, &block)
  FixtureSet.create_fixtures(ActiveSupport::TestCase.fixture_path, fixture_set_names, {}, &block)
end

ENV[Ecrire::SECRET_ENVIRONMENT_KEY] = JSON.generate({onboarding: false})
Ecrire::Application.paths.add 'config/secrets', with: Dir.pwd + '/test/secrets.yml'
Ecrire::Application.paths.add 'config/database', with: Dir.pwd + '/test/secrets.yml'

Ecrire::Application.initializer 'ecrire.automigrate', after: "active_record.initialize_database" do |app|
  path = app.paths['db/migrate'].existent
  ActiveRecord::Migrator.migrations_paths = path
  if ActiveRecord::Migrator.needs_migration?
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(path)
  end
  ActiveRecord::Migration.maintain_test_schema!
end

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  ActiveSupport.test_order = :random
  self.fixture_path = "#{Dir.pwd}/test/fixtures/"
  fixtures :all
end

Dir.chdir "test/editor/theme" do
  Ecrire::Application.initialize!
end

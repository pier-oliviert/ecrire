require "ecrire"
Dir.chdir Dir.pwd + '/test/themes/template' do
  Rails.env = 'test'
  Ecrire::Application.initialize!
end

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

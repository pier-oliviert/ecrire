$:.push File.expand_path("../lib", __FILE__)

ENV['RAILS_ENV'] ||= 'test'

require 'rake/testtask'
require 'ecrire'

task default: :test

namespace :database do

  task initialize: %w(configure) do

    begin
      # ActiveRecord's configuration assignation is done at the same time as the connection is tried
      # If it fails, the configurations aren't set in AR::Base.
      # This is why this is set here
      ActiveRecord::Base.configurations = Rails.application.config.database_configuration

      path = Rails.application.paths['db/migrate'].existent
      if ActiveRecord::Migrator.needs_migration?
        ActiveRecord::Migrator.migrate(path)
      end
    rescue ActiveRecord::NoDatabaseError
      puts 'Database does not exist. Creating...'
      ActiveRecord::Tasks::DatabaseTasks.create_current
      puts 'Database created, migrating now...'
      ActiveRecord::Migrator.migrate(path)
      puts "Migration completed."
    end

    # Right now, the only way to run all the tests is to make sure
    # the database is empty everytime it starts.
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  task :configure do
    Dir.chdir Dir.pwd + '/test/themes/template' do
      Ecrire::Application.initialize!
    end
  end

  task :purge do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

end

desc 'Configure postgres and run all tests'

task :test do
  %w(test:initializations test:editor test:themes).each do |name|
    Rake::Task[name].invoke
  end
end

namespace :test do

  tasks = %w(initializations editor themes).each do |name|
    Rake::TestTask.new(name) do |t|
      t.libs << "test"
      t.test_files = FileList["test/#{name}/**/*_test.rb"]
      t.verbose = false
      Rake::Task['database:initialize'].invoke
    end

    Rake::Task["test:#{name}"].enhance do
      Rake::Task['database:purge'].invoke
    end
  end
end

at_exit do
  Rake::Task['database:purge'].invoke
end

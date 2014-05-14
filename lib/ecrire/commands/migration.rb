module Ecrire
  class Migration
    def initialize
      @tries = 0
    end

    def configure!
      ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
      ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    end

    def migrate!
      puts 'Migrating database...'
      configure!
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
      puts 'Migration completed.'

    end
  end
end

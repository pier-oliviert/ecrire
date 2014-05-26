module Onboarding
  class DatabasesController < OnboardingController

    def create
      begin
        ActiveRecord::Base.configurations = {
          'development' => db_params,
          'production' => db_params
        }
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection
        save_configurations!
        migrate!
      rescue Exception => e
        @exception = e
        ActiveRecord::Base.clear_all_connections!
        render 'index' and return
      end
      redirect_to onboarding_users_path
    end

    private

    def migrate!
      ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
      ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
        ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
      end
    end

    def db_params
      @db_params ||= {
        'adapter' => 'postgresql',
        'database' => params[:database]['name'],
        'password' => params[:database]['password'],
        'encoding' => 'utf8'
      }
    end

    def save_configurations!
      File.open(Dir.pwd + '/config/database.yml', 'w') do |file|
        file.write(ActiveRecord::Base.configurations.to_yaml)
      end
    end

  end
end

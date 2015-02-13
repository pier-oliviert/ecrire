require_relative '../onboarding_controller'

module Onboarding
  class DatabasesController < OnboardingController
    DB_NAME = 'ecrire'
    USER = {
      name: "ecrire#{SecureRandom.hex(2)}",
      password: SecureRandom.hex(16)
    }


    helper_method :user, :db_name

    def index; end;

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
        render 'error' and return
      end
    end

    protected

    def user
      Onboarding::DatabasesController::USER
    end

    def db_name
      Onboarding::DatabasesController::DB_NAME
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
        'user' => params[:database]['user'],
        'password' => params[:database]['password'],
        'encoding' => 'utf8'
      }
    end

    def save_configurations!
      path = Dir.pwd + '/secrets.yml'
      File.open(path, 'w') do |file|
        file.write(ActiveRecord::Base.configurations.to_yaml)
      end
    end

  end
end

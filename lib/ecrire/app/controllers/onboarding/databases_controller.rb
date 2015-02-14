require_relative '../onboarding_controller'

module Onboarding
  class DatabasesController < OnboardingController

    helper_method :user, :password, :database

    def index; end;

    def create
      info ||= {
        'adapter' => 'postgresql',
        'database' => database,
        'user' => user,
        'password' => password,
        'encoding' => 'utf8'
      }
      begin
        ActiveRecord::Base.configurations = {
          'development' => info,
          'production' => info
        }
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection
        migrate!
      rescue Exception => e
        @exception = e
        ActiveRecord::Base.clear_all_connections!
        render 'index' and return
      end

      redirect_to :onboarding_users
    end

    protected

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
      params.fetch(:database, {})
    end

    def user
      @user ||= "ecrire#{SecureRandom.hex(2)}"
      db_params.fetch(:user, @user)
    end

    def password
      @password ||= SecureRandom.hex(16)
      db_params.fetch(:password, @password)
    end

    def database
      @database ||= "ecrire"
      db_params.fetch(:name, @database)
    end
  end
end

module Ecrire
  class Railtie < ::Rails::Railtie

    # This hack is done because ActiveRecord raise an error that makes
    # Ecrire exit which makes it impossible to have an instance working without a
    # database. By doing this, it becomes possible to Ecrire to load the server and
    # serve the onboarding theme for the user.
    ActiveRecord::Railtie.initializers.select do |initializer|
      initializer.name.eql? 'active_record.initialize_database'
    end.first.instance_variable_set :@block, Proc.new { |app|
      ActiveSupport.on_load(:active_record) do
        begin
          establish_connection
        rescue ActiveRecord::NoDatabaseError, ActiveRecord::AdapterNotSpecified
          app.config.middleware.delete 'ActiveRecord::QueryCache'
          app.config.middleware.delete 'ActiveRecord::ConnectionAdapters::ConnectionManagement'
        end
      end
    }

    initializer 'ecrire.secrets', before: :bootstrap_hook do |app|
      app.paths.add 'config/secrets', with: Dir.pwd + '/secrets.yml'
    end

    initializer 'ecrire.load_paths', before: :bootstrap_hook do |app|
      ActiveSupport::Dependencies.autoload_paths.unshift(*self.paths.autoload_paths)
      ActiveSupport::Dependencies.autoload_once_paths.unshift(*self.paths.autoload_once)
    end


    initializer 'ecrire.append_paths', before: :set_autoload_paths do |app|
      app.config.eager_load_paths.unshift *paths.eager_load
      app.config.autoload_once_paths.unshift *paths.autoload_once
      app.config.autoload_paths.unshift *paths.autoload_paths
    end


    initializer 'ecrire.eager_load' do
      eager_load!
    end

    class << self

      def configured?
        app = Rails.application
        begin
          app.paths.add 'config/database', with: Dir.pwd + '/secrets.yml'
          ActiveRecord::Base.configurations = app.config.database_configuration
          ActiveRecord::Base.establish_connection
          !ActiveRecord::Base.configurations.empty? && !Onboarding::User.first.nil?
        rescue Exception => e
          app.config.active_record.migration_error = :none
          ActiveRecord::Base.configurations = {}
          if Rails.env.production?
            true
          else
            false
          end
        end
      end
    end

    def eager_load!
      paths.eager_load.each do |load_path|
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_dependency(file)
        end
      end
    end


    if configured?
      require('ecrire/railtie/theme')
      include Ecrire::Railtie::Theme
    else
      require('ecrire/railtie/onboarding')
      include Ecrire::Railtie::Onboarding
    end

  end
end

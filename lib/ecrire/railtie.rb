module Ecrire
  class Railtie < ::Rails::Railtie
    require 'ecrire/railtie/onboarding'
    require 'ecrire/railtie/theme'


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

    Rails.application.paths.add 'config/database', with: Dir.pwd + '/secrets.yml'

    begin
      ActiveRecord::Base.configurations = Rails.application.config.database_configuration

      if Rails.env.production?
        include Ecrire::Railtie::Theme
      else
        ActiveRecord::Base.establish_connection
        sql = 'SELECT * from users limit(1)';
        user = ActiveRecord::Base.connection.execute(sql)
        if user.count > 0
          include Ecrire::Railtie::Theme
        else
          include Ecrire::Railtie::Onboarding
        end
      end
    rescue Exception => e
      Rails.application.config.active_record.migration_error = :none
      ActiveRecord::Base.configurations = {}
      include Ecrire::Railtie::Onboarding
    end
    
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
        rescue ActiveRecord::NoDatabaseError, ActiveRecord::AdapterNotSpecified => e
          app.config.middleware.delete 'ActiveRecord::QueryCache'
          app.config.middleware.delete 'ActiveRecord::ConnectionAdapters::ConnectionManagement'
        end
      end
    }

  end
end

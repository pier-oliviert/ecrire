module Ecrire
  module Onboarding
    class Engine < Rails::Engine

      Rails.application.config.active_record.migration_error = :none
      ActiveRecord::Base.configurations = {}

      initializer 'ecrire.load_paths', before: :bootstrap_hook do |app|
        ActiveSupport::Dependencies.autoload_paths.unshift(*self.paths.autoload_paths)
        ActiveSupport::Dependencies.autoload_once_paths.unshift(*self.paths.autoload_once)
      end

      initializer 'ecrire.append_paths', before: :set_autoload_paths do |app|
        app.config.eager_load_paths.unshift *paths.eager_load
        app.config.autoload_once_paths.unshift *paths.autoload_once
        app.config.autoload_paths.unshift *paths.autoload_paths
      end


      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(root_path)
          paths.add 'config/routes.rb', with: 'routes.rb'
          paths.add 'app/views', with: 'views'
          paths.add 'app/controllers', with: 'controllers', eager_load: true
          paths.add 'app/assets', with: 'assets', glob: '*'
          paths.add 'app/helpers', with: 'helpers', eager_load: true

          paths.add 'config/routes.rb', with: 'routes.rb'
          paths.add 'config/locales', with: 'locales', glob: '**/*.{rb,yml}'
          paths.add 'config/environments', with: 'environments', glob: "#{Rails.env}.rb"

          paths.add 'public', with: 'tmp/public'

          paths.add "lib/assets",          glob: "*"
          paths.add "vendor/assets",       glob: "*"
          paths.add "lib/tasks"
          paths
        end
      end

      def has_migrations?
        false
      end

      def root_path
        Pathname.new(__FILE__).dirname
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
end

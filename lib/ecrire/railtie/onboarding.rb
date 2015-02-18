class Ecrire::Railtie
  module Onboarding
    extend ActiveSupport::Concern
    included do
      Rails.application.config.active_record.migration_error = :none
      ActiveRecord::Base.configurations = {}

      initializer 'ecrire.onboarding.dynamic_settings' do |app|
        app.config.secret_key_base = SecureRandom.hex(16)
      end

      initializer 'ecrire.onboarding.routes' do |app|
        app.routes.clear!

        app.paths.add 'config/routes.rb', with: 'config/onboarding_routes.rb'

        paths = app.paths['config/routes.rb'].existent
        app.routes_reloader.paths.clear.unshift(*paths)
        app.routes_reloader.route_sets << app.routes
      end

      initializer 'ecrire.view_paths' do |app|
        ActionController::Base.prepend_view_path paths['onboarding:views'].existent
      end

      initializer 'ecrire.assets' do |app|
        app.config.assets.paths.concat paths['onboarding:assets'].existent
      end

      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(root_path)
          paths.add 'onboarding:views', with: 'views'
          paths.add 'onboarding:assets', with: 'assets', glob: '*'
          paths
        end
      end

      def root_path
        Pathname.new(__FILE__).dirname + '../onboarding/'
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

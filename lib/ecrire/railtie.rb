module Ecrire
  class Railtie < ::Rails::Railtie

    module Default
      extend ActiveSupport::Concern

      included do
        initializer 'ecrire.locales' do |app|
          config.i18n.railties_load_path.concat(paths['user:locales'].existent)
        end

        initializer 'ecrire.logs', before: :initialize_logger do |app|
          unless Rails.env.test?
            app.paths.add "log", with: "log/#{Rails.env}.log"
          end
        end

      end
    end

    module Onboarding
      class User < ActiveRecord::Base
      end

      extend ActiveSupport::Concern

      included do
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

        def root_path
          Pathname.new(__FILE__).dirname + 'onboarding/'
        end

      end
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


    initializer 'ecrire.helpers' do |app|
      app.config.helpers_paths.unshift(*paths['user:helpers'].existent)
    end

    initializer 'ecrire.view_paths' do |app|
      ActionController::Base.prepend_view_path paths['user:views'].existent
    end

    initializer 'ecrire.assets' do |app|
      app.config.assets.paths.concat paths['user:assets'].existent
    end

    initializer 'ecrire.eager_load' do
      eager_load!
    end

    class << self

      def configured?
        begin
          app = Rails.application
          app.paths.add 'config/database', with: Dir.pwd + '/secrets.yml'
          ActiveRecord::Base.configurations = app.config.database_configuration
          ActiveRecord::Base.establish_connection
          !ActiveRecord::Base.configurations.empty? && !Onboarding::User.first.nil?
        rescue Exception => e
          ActiveRecord::Base.configurations = {}
          if Rails.env.production?
            true
          else
            false
          end
        end
      end
    end

    def paths
      @paths ||= begin
                   paths = Rails::Paths::Root.new(root_path)

                   paths.add 'user:locales', with: 'locales', glob: '**/*.{rb,yml}'
                   paths.add 'user:assets', with: 'assets', glob: '*'
                   paths.add 'user:helpers', with: 'helpers', eager_load: true
                   paths.add 'user:decorators', with: 'decorators', eager_load: true
                   paths.add 'user:views', with: 'views'
                   paths.add 'public', with: 'tmp/public'

                   paths
                 end
    end

    def eager_load!
      paths.eager_load.each do |load_path|
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_dependency(file)
        end
      end
    end

    def root_path(file = 'config.ru')
      begin
        pathname = Pathname.pwd

        while !(pathname + file).exist? do
          pathname = pathname.parent
          if pathname.root?
            raise "Could not find #{file}. Type 'ecrire new blog_name' to create a new blog"
            break
          end
        end

        pathname
      end
    end

    if configured?
      include Default
    else
      include Onboarding
    end

  end
end

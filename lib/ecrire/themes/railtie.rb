require 'debugger'

module Ecrire
  module Themes
    class Railtie < ::Rails::Railtie

      # Initializer are called when Ecrire::Application.initialize! is called
      # Everything goes to shit if secrets isn't loaded from the right place
      
      initializer 'load secrets', before: :bootstrap_hook do |app|
        app.paths.add 'config/secrets', with: Dir.pwd + '/config/secrets.yml'
      end

      initializer 'set load paths', before: :bootstrap_hook do |app|
        ActiveSupport::Dependencies.autoload_paths.unshift(*self.paths.autoload_paths)
        ActiveSupport::Dependencies.autoload_once_paths.unshift(*self.paths.autoload_once)

        # TODO: In rails::Engine, those are set. However since I'm using a railtie, I don't have a configuration.
        # Moreover, the paths should be frozen at Rails::Paths level, not some array within the configuration
        # since those 2 are tightly coupled. So, Rails should have a method to freeze a key for a Rails::Root::Path. Patent Pending.
        # config.autoload_paths.freeze
        # config.eager_load_paths.freeze
        # config.autoload_once_paths.freeze
      end

      # TODO: Rails' configuration check for the first path in config/database. So, if the first one
      # is invalid and another one is valid, rails configuration will choke.
      # https://github.com/rails/rails/blob/master/railties/lib/rails/application/configuration.rb#L95
      # It should be paths['config/database'].existent.first
      #
      # For that reason, it's not possible to use paths << Dir.pwd + '/database.yml' and let rails figure
      # things out (Which was my initial solution)
      #
      # I need to overwrite the path instead
      initializer 'set database information', before: "active_record.initialize_database" do |app|
        # app.paths['config/database'] << Dir.pwd + '/database.yml' # Working in rails >= 4.1.2
        app.paths.add 'config/database', with: Dir.pwd + '/config/database.yml' # Until rails is fixed

        # Database folder should point to the user's folder so we can have
        # individual schema file for each project
        app.paths.add "db", with: Dir.pwd + '/db'

      end

      initializer 'load view paths' do |app|
        ActionController::Base.prepend_view_path paths['themes:views'].existent
      end

      initializer 'load assets' do |app|
        app.config.assets.paths = paths['themes:assets'].existent
      end

      initializer 'eager load' do
        eager_load!
      end

      # This is somewhat hacky for a specific reason: I want to use
      # as much as possible rails' API even if it's not great. This way,
      # I'll have a track records of API that I feel could benefit from a PR
      # upstream. 
      #
      # TODO: Refactor how helpers are handled internally in rails and PR
      initializer 'add themes helpers to application controller' do
        helpers = ApplicationController.all_helpers_from_path(paths['themes:helpers'].existent).map do |helper_name|
          "#{helper_name}_helper".camelize.constantize
        end
        ApplicationController.helper *helpers
      end

      # Paths is underused. I would actually remove eager_load: true and add a method named load!
      # which would pass the @path.existent to ActiveSupport::Dependencies. As it's either autoloaded or
      # manually loaded (Right now via eager_load!), I believe that filter is useless.
      #
      # Initializer could do something like @paths['themes:helpers'].load! and fail if a requirement fails.
      # It wouldn't be that much different than using require_dependency() in eager_load!
      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(root)
          paths.add 'themes:assets', with: "assets/#{theme_name}", glob: '*'
          paths.add 'themes:helpers', with: "helpers/#{theme_name}", eager_load: true
          paths.add 'themes:decorators', with: "decorators/#{theme_name}", eager_load: true
          paths.add 'themes:views', with: "views/#{theme_name}"

          
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

      protected

      def root
        if default?
          File.expand_path('../../themes/', __FILE__)
        else
          Dir.pwd
        end

      end

      def default?
        theme_name.eql? 'default'
      end

      def theme_name
        @theme_name ||= begin
          if Rails.application.secrets.has_key? :theme
            Rails.application.secrets[:theme]
          else
            'default'
          end
        end
      end
    end
  end
end

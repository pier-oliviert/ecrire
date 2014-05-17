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
        self.configurations = Rails.application.config.database_configuration

        begin
          establish_connection
        rescue ActiveRecord::NoDatabaseError, ActiveRecord::AdapterNotSpecified
          app.config.middleware.delete 'ActiveRecord::QueryCache'
          app.config.middleware.delete 'ActiveRecord::ConnectionAdapters::ConnectionManagement'
        end
      end
    }

    initializer 'ecrire.secrets', before: :bootstrap_hook do |app|
      app.paths.add 'config/secrets', with: Dir.pwd + '/config/secrets.yml'
    end

    initializer 'ecrire.load_paths', before: :bootstrap_hook do |app|
      # TODO: In rails::Engine, those are set. However since I'm using a railtie, I don't have a configuration.
      # Moreover, the paths should be frozen at Rails::Paths level, not some array within the configuration
      # since those 2 are tightly coupled. So, Rails should have a method to freeze a key for a Rails::Root::Path. Patent Pending.
      # config.autoload_paths.freeze
      # config.eager_load_paths.freeze
      # config.autoload_once_paths.freeze
      ActiveSupport::Dependencies.autoload_paths.unshift(*self.paths.autoload_paths)
      ActiveSupport::Dependencies.autoload_once_paths.unshift(*self.paths.autoload_once)
    end

    initializer 'ecrire.database_information', before: "active_record.initialize_database" do |app|
      # TODO: Rails' configuration check for the first path in config/database. So, if the first one
      # is invalid and another one is valid, rails configuration will choke.
      # https://github.com/rails/rails/blob/master/railties/lib/rails/application/configuration.rb#L95
      # It should be paths['config/database'].existent.first
      #
      # For that reason, it's not possible to use paths << Dir.pwd + '/database.yml' and let rails figure
      # things out (Which was my initial solution)
      #
      # I need to overwrite the path instead
      #
      # app.paths['config/database'] << Dir.pwd + '/database.yml' # Working in rails >= 4.1.2
      app.paths.add 'config/database', with: Dir.pwd + '/config/database.yml'
      app.paths.add 'config/schema', with: Dir.pwd + '/config/schema.rb'

      # Don't check for existing file as it will be created if needed.
      ActiveRecord::Tasks::DatabaseTasks.db_dir = app.paths['config/schema'].expanded.first
    end

    initializer 'ecrire.view_paths' do |app|
      if user_layout_initialized?
        ActionController::Base.prepend_view_path paths['user:views'].existent
      end
    end

    initializer 'ecrire.assets' do |app|
      app.config.assets.paths.concat paths['user:assets'].existent
      app.config.paths.add 'public', with: Dir.pwd + '/tmp/public'
    end

    initializer 'ecrire.eager_load' do
      eager_load!
    end

    initializer 'ecrire.helpers' do
      # This is somewhat hacky for a specific reason: I want to use
      # as much as possible rails' API even if it's not great. This way,
      # I'll have a track records of API that I feel could benefit from a PR
      # upstream. 
      #
      # TODO: Refactor how helpers are handled internally in rails and PR
      helpers = ApplicationController.all_helpers_from_path(paths['user:helpers'].existent).map do |helper_name|
        "#{helper_name}_helper".camelize.constantize
      end
      ApplicationController.helper *helpers
    end

    def paths
      # Paths is underused. I would actually remove eager_load: true and add a method named load!
      # which would pass the @path.existent to ActiveSupport::Dependencies. As it's either autoloaded or
      # manually loaded (Right now via eager_load!), I believe that filter is useless.
      #
      # Initializer could do something like @paths['user:helpers'].load! and fail if a requirement fails.
      # It wouldn't be that much different than using require_dependency() in eager_load!
      @paths ||= begin
                   paths = Rails::Paths::Root.new(user_path)
                   paths.add 'user:assets', with: 'assets', glob: '*'
                   paths.add 'user:helpers', with: 'helpers', eager_load: true
                   paths.add 'user:decorators', with: 'decorators', eager_load: true
                   paths.add 'user:views', with: 'views'

                   paths
                 end
    end

    def user_path
      if ActiveRecord::Base.connected?
        Dir.pwd
      else
        File.expand_path '../theme/', __FILE__
      end
    end

    def user_layout_initialized?
      layout = paths['user:views'].existent.first + '/layouts/application.html.erb'

      File.exist? layout
    end

    def eager_load!
      paths.eager_load.each do |load_path|
        Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
          require_dependency(file)
        end
      end
    end
  end
end

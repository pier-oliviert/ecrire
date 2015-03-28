module Ecrire
  module Theme
    class Engine < Rails::Engine

      initializer 'ecrire.logs', before: :initialize_logger do |app|
        unless Rails.env.test?
          app.paths.add "log", with: "log/#{Rails.env}.log"
        end
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

      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(root_path)
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

    end
  end
end

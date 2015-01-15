class Ecrire::Railtie
  module Theme
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

      initializer 'ecrire.view_paths' do |app|
        ActionController::Base.prepend_view_path paths['user:views'].existent
      end

      initializer 'ecrire.assets' do |app|
        app.config.assets.paths.concat paths['user:assets'].existent
      end

      initializer 'ecrire.helpers' do |app|
        app.config.helpers_paths.unshift(*paths['user:helpers'].existent)
      end


      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(root_path)
          paths.add 'user:views', with: 'views'
          paths.add 'user:assets', with: 'assets', glob: '*'
          paths.add 'user:locales', with: 'locales', glob: '**/*.{rb,yml}'
          paths.add 'user:helpers', with: 'helpers', eager_load: true
          paths.add 'public', with: 'tmp/public'
          paths
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


    end
  end
end

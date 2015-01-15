class Ecrire::Railtie
  module Onboarding
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

    end
  end
end

require 'warden'
require 'pg'
require 's3'
require 'kaminari'
require 'observejs'

module Ecrire
  class Application < Rails::Application
    require 'ecrire/config/environment'

    alias :require_environment! :initialize!

    initializer 'ecrire.secrets', before: :bootstrap_hook do |app|
      app.paths.add 'config/secrets', with: Dir.pwd + '/secrets.yml'
    end

    Rails.application.paths.add 'config/database', with: Dir.pwd + '/secrets.yml'

    if File.exist?(Dir.pwd + '/secrets.yml')
      require 'ecrire/theme/engine'
    else
      require 'ecrire/onboarding/engine'
    end

    def paths
      @paths ||= begin
         paths = super
         paths.add 'config/routes.rb', with: 'routes.rb'
         paths.add 'config/locales', with: 'locales', glob: "*.{rb,yml}"
         paths
       end
    end

    def self.onboarding?
      defined?(Ecrire::Onboarding::Engine)
    end

  end
end

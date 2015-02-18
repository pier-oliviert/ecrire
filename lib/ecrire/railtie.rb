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

    if File.exist?(Dir.pwd + '/secrets.yml')
      include Ecrire::Railtie::Theme
    else
      include Ecrire::Railtie::Onboarding
    end

  end
end

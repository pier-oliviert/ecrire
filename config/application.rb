require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PothiboCom
  class Application < Rails::Application
    config.from_file 'settings.yml'

    config.to_prepare do
      Warden::Strategies.add :password, PasswordStrategy
    end

    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = UnauthenticatedController.action(:failed)
    end

    Split.configure do |config|
      config.persistence = Split::Persistence::RedisAdapter.with_config lookup_by: proc { |context|
        context.session.id
      }
    end

    config.assets.precompile += [/(?:\/|\\|\A)admin\.(css|js)$/]

  end

end

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

    config.assets.precompile = [
      lambda do |filename, path|
        path =~ /(app|themes\/#{config.theme})\/assets/ && !%w(.js .css).include?(File.extname(filename))
      end,
      /(?:\/|\\|\A)(admin|application)\.(css|js)$/
    ]

    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end

    config.i18n.load_path = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    config.assets.paths = %w(images fonts javascripts stylesheets).map do |asset_type|
      (Rails.application.root + ['themes', config.theme, 'assets', asset_type].join('/')).to_s
    end

  end

end

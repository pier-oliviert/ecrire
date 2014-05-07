require 'kaminari'
require 'cubisme'
require 'warden'
require 'pg'
require 'sass-rails'
require 'jquery-rails'
require 'coffee-rails'
require 'turbolinks'


Ecrire::Application.configure do
  config = self.config
  # Todo: Remove Temporary

  config.paths.path = File.expand_path '../../', __FILE__
  config.paths.add 'app/strategies', eager_load: true
  config.paths.add 'app/forms', eager_load: true
  config.paths.add 'app/decorators', eager_load: true

  config.filter_parameters += [:password]
  config.session_store :cookie_store, key: '_ecrire_com_session'
  config.cache_classes = false

  config.eager_load = false
    
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true
    
  config.to_prepare do
    Warden::Strategies.add :password, PasswordStrategy
  end

  config.middleware.use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = SessionsController.action(:failed)
  end

  ActiveSupport.on_load(:action_controller) do
    wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
  end
end

Rails.application.configure do
  config = self.config

  config.paths.path = File.expand_path '../../', __FILE__
  config.paths.add 'app/strategies', eager_load: true
  config.paths.add 'app/forms', eager_load: true
  config.paths.add 'app/decorators', eager_load: true

  config.paths.add "config/locales", with: "locales", glob: "**/*.{rb,yml}"

  config.paths.add 'Gemfile', with: 'config/Gemfile'

  config.filter_parameters += [:password]
  config.session_store :cookie_store, key: '_ecrire_com_session'
  config.cache_classes = false

  config.eager_load = false
    
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true
    
  Warden::Manager.serialize_into_session do |user|
      user.id
  end

  Warden::Manager.serialize_from_session do |id|
      User.find_by_id(id)
  end

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

  require "ecrire/config/environment/#{Rails.env}"
end

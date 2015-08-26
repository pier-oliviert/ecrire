require 'warden'
require 'pg'
require 's3'
require 'kaminari'
require 'observejs'
require 'pg_search'

module Ecrire
  ##
  # Ecrire::Application is the entry point when running
  # a blog.
  # 
  # The big difference between this application and a normal Rails
  # application is that Ecrire will look for +secrets.yml+ in the
  # current working directory.
  #
  # If it doesn't find one, it will load the Onboarding process
  # so the user can configure the database and the first user.
  #
  # If the application finds +secrets.yml+, it will load the Theme which is located
  # in the current working directory.
  #
  #
  class Application < Rails::Application
    require 'ecrire/config/environment'

    config.before_initialize do
      if paths['config/database'].existent.any?
        require 'ecrire/theme/engine'
      else
        require 'ecrire/onboarding/engine'
      end
    end

    ##
    # There seems to be a crack between when the configuration
    # is loaded and when the initializer collection is built.
    #
    # Ecrire requires the configuration to be loaded before
    # knowing which module it should load based on the current
    # configuration.
    #
    # For that reason, this method is overloaded.
    #
    def initialize!(group=:default) #:nodoc:
      raise "Application has been already initialized." if @initialized

      ActiveSupport.run_load_hooks(:before_initialize, self)

      run_initializers(group, self)
      @initialized = true
      self
    end

    ##
    # Return paths based off Rails default plus some customization.
    #
    # These paths are Ecrire's, not the users's theme.
    #
    # For the user's paths, look at Ecrire::Theme::Engine.paths
    #
    def paths
      @paths ||= begin
         paths = super
         paths.add 'config/secrets', with: Dir.pwd + '/secrets.yml'
         paths.add 'config/database', with: Dir.pwd + '/secrets.yml'
         paths.add 'config/routes.rb', with: 'routes.rb'
         paths.add 'config/locales', with: 'locales', glob: "**/*.{rb,yml}"
         paths
       end
    end

    ##
    # Returns true if Ecrire::Onboarding::Engine is loaded
    # in the application runtime
    #
    def self.onboarding?
      defined?(Ecrire::Onboarding::Engine)
    end

    Rails::Application::Bootstrap.initializers.select do |initializer|
      initializer.name.eql? :bootstrap_hook
    end.first.instance_variable_set :@block, Proc.new {}

  end

end

require 'warden'
require 'pg'
require 's3'
require 'kaminari'
require 'observejs'
require 'written'
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
    attr_writer :pwd

    ##
    # There seems to be a crack between when the configuration
    # is loaded and when the initializer collection is built.
    #
    # Ecrire requires the configuration to be loaded before
    # knowing which module it should load based on the current
    # configuration.
    #
    # Another issue happens with railties being memoized before
    # Ecrire could figure out if the user needs to be onboarded.
    #
    # For those reasons, this method is overloaded.
    #
    def initialize!(group=:default) #:nodoc:
      raise "Application has been already initialized." if @initialized

      ActiveSupport.run_load_hooks(:before_initialize, self)
      @railties = Railties.new

      run_initializers(group, self)
      @initialized = true
      self
    end

    ##
    # Override Rails secrets management as
    # it doesn't allow us to do what we want.
    # Then, Ecrire will merge anything that is
    # through environment variables
    #
    def secrets
      @secrets ||= begin
        secrets = ActiveSupport::OrderedOptions.new
        yaml    = config.paths["config/secrets"].first

        if File.exist?(yaml)
          require "erb"
          content = YAML.load(ERB.new(IO.read(yaml)).result) || {}
          secrets.merge!(content.deep_symbolize_keys)
        end

        if ENV.has_key?(Ecrire::SECRET_ENVIRONMENT_KEY)
          require 'json'
          secrets.merge!(JSON.parse(ENV[Ecrire::SECRET_ENVIRONMENT_KEY]).deep_symbolize_keys)
        end
        
        # Fallback to config.secret_key_base if secrets.secret_key_base isn't set
        secrets.secret_key_base ||= config.secret_key_base
        # Fallback to config.secret_token if secrets.secret_token isn't set
        secrets.secret_token ||= config.secret_token

        secrets
      end
    end

    def config
      @config ||= Ecrire::Configuration.new(Pathname.new(self.class.called_from))
    end

    class << self

      ##
      # Returns true if Ecrire::Onboarding::Engine is loaded
      # in the application runtime
      #
      def onboarding?
        secrets.fetch(:onboarding, true)
      end

    end

    Rails::Application::Bootstrap.initializers.select do |initializer|
      initializer.name.eql? :bootstrap_hook
    end.first.instance_variable_set :@block, Proc.new {}

    config.before_initialize do
      require 'ecrire/config/environment'
      if onboarding?
        require 'ecrire/onboarding/engine'
      else
        require 'ecrire/theme/engine'
      end
    end


  end

end

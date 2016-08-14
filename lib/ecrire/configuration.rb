module Ecrire
  class Configuration < Rails::Application::Configuration

    def secret_key_base
      SecureRandom.hex(16)
    end

    def secret_token
      SecureRandom.hex(16)
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
         paths.add 'config/secrets', with: Ecrire::Theme.path + 'secrets.yml'
         paths.add 'config/database', with: Ecrire::Theme.path + 'secrets.yml'
         paths.add 'config/routes.rb', with: 'routes.rb'
         paths.add 'config/locales', with: 'locales', glob: "**/*.{rb,yml}"

         paths.add 'lib/tasks', with: 'tasks', glob: '**/*.rake'
         paths
       end
    end

    def database_configuration
      {
        Rails.env => Ecrire::Application.secrets.database
      }
    end

  end
end

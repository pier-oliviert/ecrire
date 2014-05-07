require 'ecrire/themes/railtie'

module Ecrire
  class Application < Rails::Application
    
    # Let's not put anything in here. Because Rails instantiate the class as soon as it's defined,
    # it's impossible to rely on any declaration made here.
    #
    # Instead, defined any configuration in config/environment.rb

  end
end


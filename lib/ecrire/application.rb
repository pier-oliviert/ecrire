require 'rails/all'
require 'thin'
require 'warden'
require 'bcrypt'
require 's3'
require 'pg'
require 'sass-rails'
require 'coffee-rails'
require 'jquery-rails'
require 'turbolinks'
require 'kaminari'
require 'cubisme'

module Ecrire
  class Application < Rails::Application
    require 'ecrire/config/environment'
    require 'ecrire/themes/railtie'

    # Let's not put anything in here. Because Rails instantiate the class as soon as it's defined,
    # it's impossible to rely on any declaration made here.
    #
    # Instead, defined any configuration in config/environment.rb

  end
end


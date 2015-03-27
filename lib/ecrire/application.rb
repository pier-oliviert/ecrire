require 'warden'
require 'pg'
require 's3'
require 'kaminari'
require 'observejs'

module Ecrire
  class Application < Rails::Application
    require 'ecrire/config/environment'
    require 'ecrire/railtie'
    require 'ecrire/route_set'

    # Let's not put anything in here. Because Rails instantiate the class as soon as it's defined,
    # it's impossible to rely on any declaration made here.
    #
    # Instead, defined any configuration in config/environment.rb
    #

    def routes
      @routes ||= Ecrire::RouteSet.new
      @routes.append(&Proc.new) if block_given?
      @routes
    end

  end
end

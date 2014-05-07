require 'rails/all'

module Ecrire

  def self.launch!
    require 'ecrire/application'
    require 'ecrire/config/environment'
    Ecrire::Application.initialize! unless Ecrire::Application.initialized?

    Rack::Server.start(app: Ecrire::Application, Port: 3000, Host: '0.0.0.0')
  end
end


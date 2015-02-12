require_relative 'commands/server'
require_relative 'commands/new'
require_relative 'commands/console'

module Ecrire
  module Commands
    def self.new
      Ecrire::Commands::New
    end

    def self.server
      Ecrire::Commands::Server
    end

    def self.console
      Ecrire::Commands::Console
    end
  end
end

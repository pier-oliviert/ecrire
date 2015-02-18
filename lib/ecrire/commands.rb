require 'ecrire/commands/server'
require 'ecrire/commands/new'
require 'ecrire/commands/console'

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

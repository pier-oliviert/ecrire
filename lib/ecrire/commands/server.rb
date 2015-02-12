require 'ecrire/commands/base'

module Ecrire
  module Commands
    class Server < Ecrire::Commands::Base

      def initialize(options = {}, *args)

        require 'ecrire'
        require 'rails/commands/server'

        shift_argv!

        @server = Rails::Server.new
        @server.options[:Port] = options[:Port]
      end

      def run!
        @server.tap do |server|
          Dir.chdir(Ecrire::Application.root)
          server.start
        end
      end

    end
  end
end

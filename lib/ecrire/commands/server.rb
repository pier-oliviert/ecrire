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
        @server.options[:Host] = options[:Host]
      end

      def run!
        @server.tap do |server|
          Ecrire::Theme.path = Pathname.new(Dir.pwd)
          Dir.chdir(Ecrire::Application.root) do
            server.start
          end
        end
      end

    end
  end
end

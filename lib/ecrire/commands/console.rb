require 'ecrire/commands/base'

module Ecrire
  module Commands
    class Console < ::Ecrire::Commands::Base
      def initialize(options = {}, *args)
      end

      def run!
        require 'ecrire'
        require 'rails/commands/console'

        shift_argv!
        Ecrire::Application.require_environment!

        Rails::Console.start(Ecrire::Application, *ARGV)
      end
    end
  end
end

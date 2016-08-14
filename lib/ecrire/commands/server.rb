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
          create_tmp_directories!
          Dir.chdir(Ecrire::Application.root)
          server.start
        end
      end

      private

      def create_tmp_directories!
        %w(cache pids sockets).each do |dir_to_make|
          FileUtils.mkdir_p(File.join(Dir.pwd, "tmp", dir_to_make))
        end
      end

    end
  end
end

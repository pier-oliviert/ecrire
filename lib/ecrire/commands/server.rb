require 'rails/commands/server'

module Ecrire
  class Server < Rails::Server

    def initialize(*)
      super
      create_tmp_directories
    end

    def create_tmp_directories
      %w(cache pids sessions sockets public).each do |dir_to_make|
        FileUtils.mkdir_p(File.join(app.root, 'tmp', dir_to_make))
      end
    end

  end
end

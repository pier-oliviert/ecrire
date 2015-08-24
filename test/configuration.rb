module Ecrire
  module Test
    module Configuration
      class Error < StandardError
      end

      require_relative 'configuration/postgresql'
    end
  end
end

module Ecrire
  class Configuration < Rails::Application::Configuration
    def secret_key_base
      SecureRandom.hex(16)
    end

    def secret_token
      SecureRandom.hex(16)
    end
  end
end

require 'sprockets/rails/task'
module Ecrire
  class Assets < ::Sprockets::Rails::Task

    def initialize(app)
      super
      self.logger = Logger.new(STDOUT)
    end

    def output
      @app.paths['public'].existent.first + @app.config.assets.prefix
    end

    def compile!
      puts "Precompiling your assets to #{output}."
      with_logger do
        manifest.compile(assets)
      end
      puts 'Precompilation finished.'
    end

  end
end

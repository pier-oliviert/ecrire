module Ecrire
  class Assets < Sprockets::Rails::SprocketsTask

    def initialize(app)
      @app = app
    end

    def output
      @app.paths['public'].existent.first + @app.config.assets.prefix
    end

    def manifest
      if app
        Sprockets::Manifest.new(index, output, app.config.assets.manifest)
      else
        super
      end
    end

  end
end

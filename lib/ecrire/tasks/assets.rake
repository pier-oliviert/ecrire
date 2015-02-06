namespace :assets do
  task :environment do
    Ecrire::Application.initialize!
  end
end

module Sprockets
  module Rails
    class Task < Rake::SprocketsTask
      def output
        File.join(Ecrire::Railtie.paths['public'].existent.first, app.config.assets.prefix)
      end
    end
  end
end

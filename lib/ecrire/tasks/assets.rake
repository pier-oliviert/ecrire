module Sprockets
  module Rails
    class Task < Rake::SprocketsTask
      def output
        File.join(Ecrire::Theme::Engine.paths['public'].expanded.first, app.config.assets.prefix)
      end
    end
  end
end

Rake::Task['assets:environment'].clear

namespace :assets do
  task :environment do
    Ecrire::Application.initialize!
  end
end


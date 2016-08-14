$:.push File.expand_path("../lib", __FILE__)

ENV['RAILS_ENV'] ||= 'test'

require 'ecrire'
require_relative 'test/task'

task default: :test

namespace :test do
  ['editor', 'onboarding', 'theme'].each do |name|
    Ecrire::Test::Task.new(name) do |t|
      t.libs << "test"
      t.test_files = FileList["test/#{name}/**/*_test.rb"]
      t.verbose = true
    end
  end
end

task :test do
  %w(test:editor test:onboarding test:theme).each do |name|
    Rake::Task[name].invoke
  end
end


namespace :template do
  desc 'Run a server set to use the template theme'
  task :server do
    require 'ecrire/commands/server'
    Dir.chdir 'lib/ecrire/theme/template'
    Rails.env = ENV['RAILS_ENV'] = 'development'
    Ecrire::Commands::Server.new(Port: 3000).run!
  end

  desc 'Run console for template development'
  task :console do
    require 'ecrire/commands/console'
    Dir.chdir 'lib/ecrire/theme/template'
    Rails.env = ENV['RAILS_ENV'] = 'development'
    Ecrire::Commands::Console.new.run!
  end

  desc 'Routes available in your current template configuration'
  task :routes do
    Dir.chdir 'lib/ecrire/theme/template'
    Rails.env = ENV['RAILS_ENV'] = 'development'
    Ecrire::Application.initialize!
    all_routes = Ecrire::Application.routes.routes
    require 'action_dispatch/routing/inspector'
    inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
    puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, ENV['CONTROLLER'])
  end
end

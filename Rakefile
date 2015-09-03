$:.push File.expand_path("../lib", __FILE__)

ENV['RAILS_ENV'] ||= 'test'

require 'ecrire'
require_relative 'test/configuration'
require_relative 'test/task'

task default: :test

namespace :database do
    secrets = YAML.load_file(File.expand_path('../test/secrets.yml', __FILE__))
    info = secrets[ENV['RAILS_ENV']]
    postgresql = Ecrire::Test::Configuration::Postgresql.new(info['database'], info['username'])

  task :initialize do
    begin
      unless postgresql.configured?
        puts "It seems you are running the development tests for the first time."
        puts "Ecrire will try to configure postgresql for you..."

        data = YAML.load_file(File.expand_path('../test/secrets.yml', __FILE__))

        if postgresql.user.new?
          postgresql.create_user!
        end

        if !postgresql.user.superuser?
          postgresql.user.superuser!
        end

        if !postgresql.user.login?
          postgresql.user.login!
        end

        puts "Done configuring postgresql."
      end

      postgresql.reset_database!
    rescue Ecrire::Test::Configuration::Error => e
      puts "Ecrire couldn't configure postgresql."
      puts "=> #{e.message}"
      puts "To fix this issue, make sure you have a superuser for #{%x(whoami)}"
      puts "createuser -l -s postgres"
      exit
    end
  end

end

namespace :test do
  ['editor', 'onboarding', 'theme'].each do |name|
    Ecrire::Test::Task.new(name) do |t|
      t.before do
        Rake::Task['database:initialize'].invoke
      end
      t.libs << "test"
      t.test_files = FileList["test/#{name}/**/*_test.rb"]
      t.verbose = true
    end
  end

  Rake::TestTask.new 'markdown' do |t|
    t.libs << "test"
    t.test_files = FileList["test/markdown/**/*_test.rb"]
    t.verbose = true
  end


end

task :test do
  %w(test:markdown test:editor test:onboarding test:theme).each do |name|
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

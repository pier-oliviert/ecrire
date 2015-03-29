$:.push File.expand_path("../lib", __FILE__)

ENV['RAILS_ENV'] ||= 'test'

require 'ecrire'
require_relative 'test/test_task'

task default: :test

namespace :database do

  task :purge do
    [User, Post, Image, Partial, Title].each(&:delete_all)
  end

end

namespace :test do
  ['editor', 'onboarding'].each do |name|
    task = Ecrire::TestTask.new(name) do |t|
      t.theme = Dir.pwd + "/test/#{name}/theme"
      t.libs << "test"
      t.test_files = FileList["test/#{name}/**/*_test.rb"]
      t.verbose = true
    end
  end

end

at_exit do
  unless Ecrire::Application.onboarding?
    Rake::Task['database:purge'].invoke
  end
end

$:.push File.expand_path("../lib", __FILE__)
require 'rake/testtask'
require_relative 'test/config/database'

namespace :test do

  Rake::TestTask.new(:initializations) do |t|
    t.libs << "test"
    t.test_files = FileList['test/initializations/**/*_test.rb']
    t.verbose = false
  end

  Rake::TestTask.new(:editor) do |t|
    t.libs << "test"
    t.test_files = FileList['test/editor/**/*_test*.rb']
    t.verbose = false
  end

  Rake::TestTask.new(:themes) do |t|
    t.libs << "test"
    t.test_files = FileList['test/themes/**/test*.rb']
    t.verbose = false
  end
end

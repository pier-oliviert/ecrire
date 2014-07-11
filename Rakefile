$:.push File.expand_path("../lib", __FILE__)

Dir.chdir Dir.pwd + '/test/theme' do
  require 'bundler/cli'
  Bundler::CLI.new.install

  require 'ecrire'
  Ecrire::Application.load_tasks
end

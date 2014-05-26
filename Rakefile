# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

Dir.chdir(File.expand_path('../lib', __FILE__)) do
  require 'ecrire'

  Dir.chdir Pathname.pwd + '../test' do
    Ecrire::Application.initialize!
  end

  Ecrire::Application.load_tasks

end

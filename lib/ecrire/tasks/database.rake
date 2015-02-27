namespace :db do
  task :environment do
    Ecrire::Application.initialize!
  end

end

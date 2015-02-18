task routes: :environment do
  Rails.application.paths.add 'config/routes.rb', with: 'config/routes.rb', eager_load: true
  Rails.application.paths['config/routes.rb'].existent.each do |path|
    require path
  end
end

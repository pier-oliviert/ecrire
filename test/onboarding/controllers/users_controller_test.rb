require 'test_controller'

class UsersControllerTest < TestController
  tests UsersController

  # I'm hardcoding those values right now because I think
  # it's easy for someone to set a new database. Maybe I could make these test depends on
  # the databases controller so the setup would actually be a simple posts to that controller..
  # 
  # On the flip side, that would make it look like an integration tests... anyway.
  setup do
    info ||= {
      'adapter' => 'postgresql',
      'user' => 'ecrire_test',
      'database' => 'ecrire_test',
      'password' => 'password',
      'encoding' => 'utf8'
    }
    ActiveRecord::Base.configurations = { 'test' => info }
    ActiveRecord::Base.establish_connection
    migrate!
    @routes = Ecrire::Onboarding::Engine.routes
  end

  def migrate!
    ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
    ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
      ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
    end
  end


  test 'should show errors if there are problems with the user submitted' do
    post :create, user: { email: 'bob@dilan.ca', password: 'password', password_confirmation: 'password1' }
    assert_template :index
    assert_select 'div.error' do 
      assert_select 'p', 1
    end
  end


  test 'configuration should be saved as soon as the user is created' do
    post :create, user: { email: 'bob@dilan.ca', password: 'password', password_confirmation: 'password' }
    assert_redirected_to '/'
    assert Rails.application.paths['config/secrets'].existent.any?
  end

  teardown do
    file = Rails.application.paths['config/secrets'].existent
    FileUtils.rm(file) unless file.nil?
  end
end

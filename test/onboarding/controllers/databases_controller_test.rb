require 'test_controller'

class DatabasesControllerTest < TestController
  tests DatabasesController

  setup do
    @routes = Ecrire::Onboarding::Engine.routes
  end

  test 'show error if the connection is refused' do
    post :create, database: {user: 'invalid!', password: 'Nothing', name: 'ecrire_test'}
    assert_response :success
    assert_select 'div.error' do
      assert_select 'p', 1
    end
  end

  test 'even if the connection to the server is done, secrets.yml is not yet generated' do
    post :create, database: {user: 'ecrire_test', password: '', name: 'ecrire_test'}
    assert Rails.application.paths['config/secrets'].existent.empty?
  end

  test 'redirect to users if the connection is successful' do
    post :create, database: {user: 'ecrire_test', password: '', name: 'ecrire_test'}
    assert_redirected_to '/users'
  end

end

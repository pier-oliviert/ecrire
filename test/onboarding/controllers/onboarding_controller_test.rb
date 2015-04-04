require 'test_controller'

class OnboadingControllerTest < TestController
  tests OnboardingController

  setup do
    @routes = Ecrire::Onboarding::Engine.routes
  end

  test 'show welcome page when using access the root page' do
    get :index
    assert_response :success
    assert_template :welcome
  end


  test 'show complete page if secrets.yml exists' do
    File.open(Rails.application.paths['config/secrets'].expanded.last, 'w') do |file|
      file.write('')
    end

    get :index
    assert_response :success
    assert_template :complete
  end

  teardown do
    file = Rails.application.paths['config/secrets'].existent
    FileUtils.rm(file) unless file.nil?
  end
end

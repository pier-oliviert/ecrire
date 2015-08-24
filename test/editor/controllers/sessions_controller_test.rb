require 'test_controller'

class SessionsControllerTest < TestController
  test 'should be able to log in' do
    post :create, session: {email: "pothibo@gmail.com", password: "123456789"}
    assert !proxy.user.nil?, "#{users(:pothibo).email} should be logged in"
    assert_redirected_to '/'
  end


  # From what I could read, functional tests do not play nice with middlewares.
  # So, because I can't rely on Warden::Manager to catch the thrown error here, I 
  # have 2 options: Move to integration testing or work around the issue. 
  # I chose the later for now but I believe that it might be a good idea to move controller
  # testing to actual integration tests. Most of the work is done on the UI anyway so it would
  # cover every cases. 
  test 'show and error if your credentials do not satisfy' do
    catch :warden do
      post :create, session: {email: "pothibo@gmail.com", password: "ksjaslk"}
    end
    assert proxy.user.nil?, "#{users(:pothibo).email} should NOT be logged in"
  end
end

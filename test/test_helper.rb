ENV["RAILS_ENV"] ||= "test"
require 'rails/test_help'

class ActiveSupport::TestCase
  Dir.chdir Dir.pwd + '/test/theme' do
    Ecrire::Application.initialize!
  end
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Warden::Test::Helpers

end

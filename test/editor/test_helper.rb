require 'rails/all'
require 'ecrire'
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveSupport.test_order = :sorted
  self.fixture_path = "#{Dir.pwd}/test/fixtures"
  fixtures :all

  # Need to quick boot an instance of Ecrire to check if a user
  # exists. It creates a new user if none exists so the editor can be launched
  pid = fork do
    Dir.chdir Dir.pwd + '/test/themes/template' do
      Ecrire::Application.initialize!
      ::User.first_or_create!(email: 'test@test.ca', password: 123456)
    end
    exit!
  end

  Process.wait2(pid)

  Dir.chdir Dir.pwd + '/test/themes/template' do
    Ecrire::Application.initialize!
  end

  include Warden::Test::Helpers

end

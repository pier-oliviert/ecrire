ENV['VERBOSE'] = 'false'

class ActiveSupport::TestCase
  ActiveSupport.test_order = :random
end

Dir.chdir "test/onboarding/theme" do
  Ecrire::Application.initialize!
end


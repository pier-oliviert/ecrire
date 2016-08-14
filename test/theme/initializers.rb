require_relative '../configuration'

ENV[Ecrire::SECRET_ENVIRONMENT_KEY] = JSON.generate({
  onboarding: false,
  database: {
    adapter: 'postgresql',
    username: 'ecrire_test',
    database: 'ecrire_test'
  }
})

Dir.chdir "test/theme/theme" do
  Ecrire::Application.initialize!
  postgresql = Ecrire::Test::Configuration::Postgresql.new(Ecrire::Application)
  postgresql.configure!
  postgresql.reset_database!

end

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  ActiveSupport.test_order = :random
  self.fixture_path = "#{Dir.pwd}/test/fixtures/"
  fixtures :all
end



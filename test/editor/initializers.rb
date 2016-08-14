require_relative '../configuration'

ENV[Ecrire::SECRET_ENVIRONMENT_KEY] = JSON.generate({
  onboarding: false,
  adapter: 'postgresql',
  database: 'ecrire_test',
  username: 'ecrire_test',
  secret_key: "2370 128u3o2ujwoi12jw122e12e",
  secret_key_base: "Mlkasj alskjkdsla jsdkaljsadlkjasd",
  s3: {
    path: 'test'
  }
})

Dir.chdir "test/editor/theme" do
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


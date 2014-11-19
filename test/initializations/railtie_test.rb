require "isolation"

class RailtieTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::Isolation

  def test(name, &block)
    run_in_isolation do
      super name, &block
    end
  end

  test 'Ecrire onboards by default' do
    require 'ecrire'
    Ecrire::Application
    assert !Ecrire::Railtie.configured?
    assert Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
    assert !Ecrire::Railtie.include?(Ecrire::Railtie::Default)
  end

  test 'Ecrire never onboards in production' do
    old_env = ENV['RAILS_ENV']
    ENV['RAILS_ENV'] = 'production'
    require 'ecrire'
    Ecrire::Application
    assert Ecrire::Railtie.configured?
    assert !Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
    assert Ecrire::Railtie.include?(Ecrire::Railtie::Default)
    ENV['RAILS_ENV'] = old_env
  end

  test 'not configured if no user is present in the database' do
    Dir.chdir 'test/themes/template' do
      require 'ecrire'
      Ecrire::Application
      class User < ActiveRecord::Base; end
      User.destroy_all
      assert !Ecrire::Railtie.configured?
      assert Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
      assert !Ecrire::Railtie.include?(Ecrire::Railtie::Default)
    end
  end

  test 'configured completely if a connection to the database can be made' do
    Dir.chdir 'test/themes/template' do

      run_in_isolation do
        require 'ecrire'
        Ecrire::Application.initialize!
        ::User.first_or_create!(email: 'test@test.ca', password: 123456)
      end

      require 'ecrire'
      Ecrire::Application.initialize!

      assert Ecrire::Railtie.configured?
      assert !Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
      assert Ecrire::Railtie.include?(Ecrire::Railtie::Default)
      User.first.destroy
    end
  end

end

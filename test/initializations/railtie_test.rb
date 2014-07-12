require "initializations/isolation"

class RailtieTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::Isolation

  def test(name, &block)
    run_in_isolation do
      super name, &block
    end
  end

  test 'Ecrire onboards by default' do
    require 'ecrire'
    require 'ecrire/application'
    assert !Ecrire::Railtie.configured?
    assert Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
    assert !Ecrire::Railtie.include?(Ecrire::Railtie::Default)
  end

  test 'Ecrire never onboards in production' do
    old_env = ENV['RAILS_ENV']
    ENV['RAILS_ENV'] = 'production'
    require 'ecrire'
    require 'ecrire/application'
    assert Ecrire::Railtie.configured?
    assert !Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
    assert Ecrire::Railtie.include?(Ecrire::Railtie::Default)
    ENV['RAILS_ENV'] = old_env
  end

  test 'Ecrire loads up completely if a connection to the database can be made' do
    Dir.chdir 'test/themes/template' do
      require 'ecrire'
      require 'ecrire/application'
      assert Ecrire::Railtie.configured?
      assert !Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
      assert Ecrire::Railtie.include?(Ecrire::Railtie::Default)
    end
  end

end

require "isolation"

class RailtieTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::Isolation

  def teardown
    Object.send(:remove_const, :Ecrire)
  end

  test 'Ecrire onboards by default' do
    require 'ecrire'
    Ecrire::Application.initialize!
    assert Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
    assert !Ecrire::Railtie.include?(Ecrire::Railtie::Theme)
  end

  test 'not configured if no user is present in the database' do
    Dir.chdir 'test/themes/template' do

      require 'ecrire'
      Ecrire::Application.initialize!

      assert Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
      assert !Ecrire::Railtie.include?(Ecrire::Railtie::Theme)
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

      assert !Ecrire::Railtie.include?(Ecrire::Railtie::Onboarding)
      assert Ecrire::Railtie.include?(Ecrire::Railtie::Theme)
      # Need to destroy the user here because parallelization is fubar'ed
      # and it's the most stable way I found it.
      # All other options seemed to introduce racing conditions.
      User.destroy_all
    end
  end

end

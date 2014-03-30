require 'test_helper'

class BaseControllerTest < ActionController::TestCase
  include Warden::Test::Helpers

  def self.manager
    @manager ||= Warden::Manager.new(self)
  end

  def setup
    @controller.env['warden'] = Warden::Proxy.new(@controller.env, BaseControllerTest.manager)
  end

  def teardown
    Warden.test_reset!
  end

  def proxy
    @controller.env['warden']
  end

end

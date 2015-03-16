require 'editor/test_helper'
require 'byebug'

class BaseControllerTest < ActionController::TestCase
  include Warden::Test::Helpers

  def self.manager
    @manager ||= Warden::Manager.new(self,
      {
        default_strategies: :password,
        failure_app: SessionsController.action(:failed)
      })
  end

  def setup
    @controller.env['warden'] = @request.env['warden'] = Warden::Proxy.new(@request.env, self.class.manager)
  end

  def teardown
    Warden.test_reset!
  end

  def proxy
    @controller.env['warden']
  end

end

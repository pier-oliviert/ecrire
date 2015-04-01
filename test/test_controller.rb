require 'test_helper'
require 'warden'

class TestController < ActionController::TestCase

  def setup
    @routes = Rails.application.routes
    @controller.env['warden'] = @request.env['warden'] = Warden::Proxy.new(@request.env, self.class.manager)
  end

  def log_in!(user = nil)
    user ||= User.first
    proxy.set_user user
  end

  def self.manager
    @manager ||= Warden::Manager.new(self,
      {
        default_strategies: :password,
        failure_app: SessionsController.action(:failed)
      })
  end

  def teardown
    Warden.test_reset!
  end

  def proxy
    @controller.env['warden']
  end

end


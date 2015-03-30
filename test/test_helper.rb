require 'ecrire'
require 'rails/all'

require 'active_support/testing/autorun'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_case'
require 'action_dispatch/testing/integration'
require 'rails/generators/test_case'

require 'warden'
require 'byebug'

Dir.chdir ARGV.pop do
  Ecrire::Application.initialize!
end


class ActiveSupport::TestCase
  ActiveSupport.test_order = :sorted
end

class ActionController::TestCase
  include Warden::Test::Helpers

  setup do
    @routes = Rails.application.routes
  end
end



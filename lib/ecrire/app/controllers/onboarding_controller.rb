class RedirectFilter
  def self.before(controller)
    new(controller).dispatch!
  end

  def initialize(controller)
    @controller = controller
  end

  def dispatch!
    if user_configured?
      @controller.configuration_completed!
    elsif database_configured?
      @controller.configure_user!
    else
      @controller.configure_database!
    end
  end

  protected

  def database_configured?
    @database_configured ||= begin
                               !ActiveRecord::Base.connection.nil?
                             rescue ActiveRecord::ActiveRecordError
                               false
                             end
  end

  def user_configured?
    @user_configured ||= begin
                           !User.first.nil?
                         rescue ActiveRecord::ActiveRecordError
                           false
                         end
  end
end

class OnboardingController < ApplicationController
  rescue_from ActiveRecord::ActiveRecordError, with: :database_not_configured
  before_action ::RedirectFilter, only: :index

  def index
  end

  def complete
  end

  def configure_user!
    if !is_a?(Onboarding::UsersController)
      redirect_to onboarding_users_path
    end
  end

  def configure_database!
    if !is_a?(Onboarding::DatabasesController)
      redirect_to onboarding_databases_path
    end
  end

  def configuration_completed!
    if !instance_of?(OnboardingController)
      redirect_to onboarding_complete_path
    end
  end

  protected

  def database_not_configured
    redirect_to onboarding_databases_path
  end

end

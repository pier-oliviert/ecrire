class RedirectFilter

  def self.before(controller)
    if OnboardingController.welcome?
      new(controller).dispatch!
    end
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
  @@welcomed = false
  rescue_from ActiveRecord::ActiveRecordError, with: :database_not_configured
  before_action ::RedirectFilter, only: :index

  class << self
    @welcome = false
    def welcome?
      !!@welcome
    end

  end

  def index
    render 'welcome'
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
      redirect_to :root
    end
  end

  def generate_secret_key_base!
    path = Rails.application.paths['config/secrets'].expanded.first
    config = YAML.load_file(path)
    config['development']['secret_key_base'] = config['production']['secret_key_base'] = SecureRandom.hex(64)
    File.open(path, 'w') do |file|
      file.write(config.to_yaml)
    end


  end

  protected

  def database_not_configured
    redirect_to onboarding_databases_path
  end

end

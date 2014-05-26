module Onboarding
  class UsersController < OnboardingController

    helper_method :user

    def index; end;

    def create
      @user = User.create(user_params)
      
      if user.errors.blank?
        redirect_to :root
      else
        render 'index'
      end
    end

    protected

    def user
      @user ||= User.new
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

  end
end

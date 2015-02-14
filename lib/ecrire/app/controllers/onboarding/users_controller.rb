module Onboarding
  class UsersController < OnboardingController

    helper_method :user

    def index;end;

    def create
      @user = User.find_or_create_by(email: user_params[:email])
      @user.update(user_params)
      
      if user.errors.blank?
        save_configurations!
        redirect_to :root
      else
        render 'index'
      end
    end

    protected


    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def user
      @user ||= User.new
    end

  end
end

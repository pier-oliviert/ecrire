class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  
  def current_user
    warden.user
  end

  def signed_in?
    !warden.user.nil?
  end

  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end

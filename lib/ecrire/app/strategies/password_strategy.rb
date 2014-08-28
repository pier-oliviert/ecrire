class PasswordStrategy < Warden::Strategies::Base
  def valid?
    return false if request.get?
    user_data = params.fetch("session", {})
    user_data.has_key?("email") && user_data.has_key?("password")
  end

  def authenticate!
    user = User.find_by_email(params["session"].fetch("email"))
    if !user.nil? && user.password == params["session"].fetch("password")
      success! user
    else
      env['warden'].errors.add :general, "Sorry, couldn't log you in."
      fail! 
    end
  end
end

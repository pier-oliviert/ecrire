class PasswordStrategy < Warden::Strategies::Base
  def valid?
    return false if request.get?
    user_data = params.fetch("session", {})
    user_data.has_key?("email") && user_data.has_key?("password")
  end

  def authenticate!
    user = User.find_by_email(params["session"].fetch("email"))
    if user.nil? || user.password != params["session"].fetch("password")
      env['warden'].errors.add 'no.match', "Sorry, couldn't log you in."
      fail! 
    else
      success! user
    end
  end
end

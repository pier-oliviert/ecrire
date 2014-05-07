class PasswordStrategy < Warden::Strategies::Base
  def valid?
    return false if request.get?
    user_data = params.fetch("session", {})
    !(user_data["email"].blank? || user_data["password"].blank?)
  end

  def authenticate!
    user = User.find_by_email(params["session"].fetch("email"))
    if user.nil? || user.password != params["session"].fetch("password")
      fail! :message => "strategies.password.failed"
    else
      success! user
    end
  end
end

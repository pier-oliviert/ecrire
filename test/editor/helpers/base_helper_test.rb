require 'editor/test_helper'

class BaseHelperTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  def signed_in?
    !@user.nil?
  end

  def current_user
    @user
  end

  protected

  def sign_user_in!
    @user = User.allocate
  end

end


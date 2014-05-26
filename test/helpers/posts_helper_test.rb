class PostsHelperTest < BaseHelperTest

  attr_accessor :post

  test 'admin_edit_link is only rendered if the user is signed in' do
    html = admin_edit_link
    assert html.blank?

    sign_user_in!

    self.post = posts(:published)
    html = admin_edit_link
    assert !html.blank?
  end

end


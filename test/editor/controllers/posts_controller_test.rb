require 'test_controller'
require 'editor/test_helper'

class PostsControllerTest < TestController
  tests Admin::PostsController

  test "cannot create a new post if the user isn't logged in" do
    assert_throws :warden, "Expecting Warden to throw a symbol" do
      post :create, post: {title: 'A new post'}
    end
  end

  test 'creating a new post should redirect to the editor' do
    log_in!
    post :create, post: {title: 'A new post'}
    assert_redirected_to @controller.url('/admin/posts/:post.id/edit', post: assigns(:post))
  end

  test 'a new post with an existing title should render errors' do
    log_in!
    post :create, post: {title: Post.first.title}
    assert_select 'ul.errors' do
      assert_select 'li[key=title]'
    end
  end

  test "publishing a post redirect the user to the post's URL" do
    log_in!
    put :update, id: Post.status(:draft).first.id, button: :publish
    assert_redirected_to @controller.url(Ecrire::Theme::Engine.post_path, post: assigns(:post))
  end
end

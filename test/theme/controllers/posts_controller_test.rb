require 'test_controller'
require 'test_helper'

class PostsControllerTest < TestController
  tests PostsController

  setup do
    @routes = Ecrire::Theme::Engine.routes
  end

  test "redirect if page doesn't exist" do
    get :show, year: 323, month: 1, id: "doesn't exist"
    assert_redirected_to '/'
  end

  test 'show post if it exists' do
    p = Post.published.first
    get :show, year: p.year, month: p.month, id: p.slug
    assert_response :success, response.inspect
  end

end

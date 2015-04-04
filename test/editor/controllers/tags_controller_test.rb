require 'test_controller'
require 'editor/test_helper'

class TagsControllerTest < TestController
  tests Admin::Posts::TagsController

  test 'can create a new tag' do
    log_in!
    post :create, post_id: Post.published.last, tag: {name: 'A new tag'}, format: :js
    assert_response :success
  end

end


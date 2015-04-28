require 'test_controller'
require 'editor/test_helper'

class TagsControllerTest < TestController
  tests Admin::TagsController

  test 'can create a new tag' do
    log_in!
    post :create, post_id: Post.published.last, tag: {name: 'A new tag'}
    assert_redirected_to '/admin/tags'
  end

end

require 'test_helper'

class PostsHelperTest < ActionView::TestCase

  test "suggested post shouldn't include the current post" do
    @post = Post.create(title: "another published post", published_at: 5.minutes.ago)
    assert !suggested_posts(@post).include?(@post), "Shouldn't include the current post"
  end

end

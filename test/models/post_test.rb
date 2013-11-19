require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "fetch published post" do
    @posts = Post.status("published")
    assert_equal @posts.count, Post.published.count
    @posts.each do |post|
      assert post.published?
    end
  end

  test "fetch draft post" do
    @posts = Post.status("draft")
    assert_equal @posts.count, Post.drafted.count
    @posts.each do |post|
      assert post.draft?
    end
  end

  test "publishing a post" do
    @post = Post.new
    @post.title = "Some new post"
    assert @post.draft?, "Should be a draft"
    @post.publish!
    assert @post.published?, "Should be published"
  end

  test "publishing date shouldn't change once set" do
    @post = posts(:published)
    published_at = @post.published_at
    @post.publish!
    assert_equal published_at, @post.published_at, "Shouldn't be able to change the published date"
  end

  test "should create a slug if none exist" do
    @post = Post.new
    @post.title = "some test"
    @post.save
    assert !@post.slug.nil?
  end

  test "excerpt should only be readable HTML" do
    @post = Post.new title: "Some other test"
    @post.content = "
    <script>some JS</script>
    <style>Some CSS</style>
    <h1>A header</h1>
    <p>And a paragraph</p>"
    @post.save

    assert_equal @post.excerpt, "A header And a paragraph..."
  end
end

require 'editor/test_helper'

class PostTest < ActiveSupport::TestCase
  test 'post can have tags' do
    tag = tags(:ruby)
    post = posts(:published)
    post.tags << tag
    assert post.save, post.errors.full_messages.to_sentence
    assert post.tags.include?(tag)
    assert post.read_attribute(:tags).include?(tag.id)
  end

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

  test 'fetch post without a specific one' do
    excluded_post = posts(:published)
    Post.without(excluded_post).each do |post|
      assert_not_equal post, excluded_post, "The excluded post shouldn't be part of the result"
    end
  end

  test "publishing a post" do
    @post = Post.new
    @post.titles << Title.new(name: "Some new post", post: @post)
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

  test "exerpt does not include images" do
    post = Admin::Post.new({
      content: "Hello
      ![a](http://google.com)"
    })

    post.titles << Admin::Title.new(name: "Post Image test.", post: post)

    assert post.save, post.errors.full_messages.to_sentence

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('p').length > 0
    assert_equal html.css('img').length, 0, "There shouldn't be image within excerpt"

  end

end

require 'editor/test_helper'

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

  test 'fetch post without a specific one' do
    excluded_post = posts(:published)
    Post.without(excluded_post).each do |post|
      assert_not_equal post, excluded_post, "The excluded post shouldn't be part of the result"
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
    !@post.save
    assert !@post.slug.nil?
  end

  test "can't save a post if the title already exists" do
    @old_post = Post.first
    @post = Post.new
    @post.title = @old_post.title
    assert !@post.save, "The post shouldn't save."
    assert @post.errors.has_key?(:title), 'There should be an error with the title'
  end

  test "exerpt does not include images" do
    post = Admin::Post.create!({
      title: "A new post",
      content: "Hello
      ![a](http://google.com)"
    })

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('p').length > 0
    assert_equal html.css('img').length, 0, "There shouldn't be image within excerpt"

  end

  test "can't save a post if the slug already exists" do
    @old_post = Post.first
    @post = Post.new
    @post.slug = @old_post.slug
    assert !@post.save, "The post shouldn't save."
    assert @post.errors.has_key?(:slug), 'There should be an error with the slug'
  end

  test 'should be able to add labels' do
    @post = posts(:draft)
    label = Label.create(name: 'A label')
    @post.labels = [label]
    assert @post.save
  end

  test 'labels are arrays of Label' do
    @post = posts(:draft)
    label = Label.create(name: 'A label')
    @post.labels = [label]
    assert @post.save
    assert_equal @post.labels.first, label
    assert_kind_of Array, @post.labels
    assert_kind_of Label, @post.labels.first
  end

  test 'labels are instance of Label' do
  end

end

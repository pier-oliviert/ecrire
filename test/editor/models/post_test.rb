require 'test_helper'
require 'editor/test_helper'

class PostTest < ActiveSupport::TestCase

  test 'creation will bind a new title to this post' do
    post = Post.new
    post.title = "test"
    assert post.save, post.errors.full_messages.to_sentence
    assert post.titles.count == 1
    post.titles.each do |title|
      assert title.persisted?
    end
  end

  test 'post can have tags' do
    tag = tags(:ruby)
    post = posts(:published)
    post.tags << tag
    assert post.save, post.errors.full_messages.to_sentence
    assert post.tags.include?(tag)
    assert post.read_attribute(:tags).include?(tag.id)
  end

  test 'find post by title' do
    keyword = 'title'

    posts = Title.search_by_name(keyword).map(&:post).uniq

    assert posts.count == Post.search_by_title(keyword).count

    Post.search_by_title(keyword).each do |post|
      assert posts.include?(post)
    end
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

  test "excerpt is generated until it reaches 20 elements" do
    post = Admin::Post.new({
      content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Nunc malesuada diam id fringilla varius.
Suspendisse ultricies sem ac enim pulvinar luctus.
Pellentesque a nunc in libero convallis fringilla.
Praesent nec ipsum ut turpis feugiat semper.
Integer quis magna quis nisi porta hendrerit in a lorem.
Nam dignissim sapien nec feugiat cursus.
In tincidunt orci eget est scelerisque, a consequat massa consectetur.
Donec et nunc at justo facilisis congue.
Cras mollis orci ac arcu consectetur, quis bibendum leo gravida.
Vivamus dapibus dolor eu tortor molestie, non pulvinar risus dignissim.
Aliquam vitae lectus vehicula, euismod ex at, accumsan quam.
Ut vulputate mauris hendrerit mauris placerat tempus quis eget diam.
Sed vestibulum lacus eu vehicula finibus.
Praesent non diam vitae eros congue pretium.
Nulla tincidunt justo sit amet aliquet porta.
Nam vel elit vitae diam mattis mattis.
Phasellus in lacus eget sem tempus elementum.
Integer gravida diam sit amet massa egestas convallis.
Vestibulum dignissim odio sit amet sem condimentum, ut pharetra erat bibendum.
Cras molestie tellus id convallis lobortis."
    })

    post.titles << Admin::Title.new(name: "Post Excerpt test.", post: post)

    assert post.save, post.errors.full_messages.to_sentence

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('body > *').length == 20

  end

  test "excerpt generation stops when it reaches an element that can't be part of it" do
    post = Admin::Post.new({
      content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
[Nunc](http://google.com) malesuada diam id fringilla varius.
Suspendisse ultricies sem ac enim pulvinar luctus.
Pellentesque a nunc in libero convallis fringilla.
Praesent nec ipsum ut turpis feugiat semper.
Integer quis magna quis nisi porta hendrerit in a lorem.
Nam dignissim sapien nec feugiat cursus.
- In tincidunt orci eget est scelerisque, a consequat massa consectetur.
- Donec et nunc at justo facilisis congue.
- Cras mollis orci ac arcu consectetur, quis bibendum leo gravida.
Vivamus dapibus dolor eu tortor molestie, non pulvinar risus dignissim.
Aliquam vitae lectus vehicula, euismod ex at, accumsan quam.
# Ut vulputate mauris hendrerit mauris placerat tempus quis eget diam.
Sed vestibulum lacus eu vehicula finibus.
Praesent non diam vitae eros congue pretium.
Nulla tincidunt justo sit amet aliquet porta.
Nam vel elit vitae diam mattis mattis.
Phasellus in lacus eget sem tempus elementum.
Integer gravida diam sit amet massa egestas convallis.
Vestibulum dignissim odio sit amet sem condimentum, ut pharetra erat bibendum.
Cras molestie tellus id convallis lobortis."
    })

    post.titles << Admin::Title.new(name: "Post Excerpt test.", post: post)

    assert post.save, post.errors.full_messages.to_sentence

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('body > *').length == 10
  end

end

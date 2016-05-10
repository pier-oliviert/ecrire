require 'test_helper'

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
    @posts = Post.status("drafted")
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

  test "excerpt is generated until it reaches 5 elements" do
    post = Admin::Post.new({
      content: {
        raw: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
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
Cras molestie tellus id convallis lobortis.",
        html: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
<p>Nunc malesuada diam id fringilla varius.</p>
<p>Suspendisse ultricies sem ac enim pulvinar luctus.</p>
<p>Pellentesque a nunc in libero convallis fringilla.</p>
<p>Praesent nec ipsum ut turpis feugiat semper.</p>
<p>Integer quis magna quis nisi porta hendrerit in a lorem.</p>
<p>Nam dignissim sapien nec feugiat cursus.</p>
<p>In tincidunt orci eget est scelerisque, a consequat massa consectetur.</p>
<p>Donec et nunc at justo facilisis congue.</p>
<p>Cras mollis orci ac arcu consectetur, quis bibendum leo gravida.</p>
<p>Vivamus dapibus dolor eu tortor molestie, non pulvinar risus dignissim.</p>
<p>Aliquam vitae lectus vehicula, euismod ex at, accumsan quam.</p>
<p>Ut vulputate mauris hendrerit mauris placerat tempus quis eget diam.</p>
<p>Sed vestibulum lacus eu vehicula finibus.</p>
<p>Praesent non diam vitae eros congue pretium.</p>
<p>Nulla tincidunt justo sit amet aliquet porta.</p>
<p>Nam vel elit vitae diam mattis mattis.</p>
<p>Phasellus in lacus eget sem tempus elementum.</p>
<p>Integer gravida diam sit amet massa egestas convallis.</p>
<p>Vestibulum dignissim odio sit amet sem condimentum, ut pharetra erat bibendum.</p>
<p>Cras molestie tellus id convallis lobortis.</p>",
      }
    })

    post.titles << Admin::Title.new(name: "Post Excerpt test.", post: post)

    assert post.save, post.errors.full_messages.to_sentence

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('body > *').length == 5, html.to_s

  end

  test "excerpt generation stops when it reaches an element that can't be part of it" do
    post = Admin::Post.new({
      content: {
        raw: "",
        html: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
          <p>Nunc malesuada diam id fringilla varius.</p>
          <ul>
            <li>Suspendisse ultricies sem ac enim pulvinar luctus.</li>
            <li>Pellentesque a nunc in libero convallis fringilla.</li>
          </ul>
          <h1>Praesent nec ipsum ut turpis feugiat semper.</h1>
          <p>Integer quis magna quis nisi porta hendrerit in a lorem.</h1>
          <p>Nam dignissim sapien nec feugiat cursus.</p>
          <p>In tincidunt orci eget est scelerisque, a consequat massa consectetur.</p>
          <p>Donec et nunc at justo facilisis congue.</p>
          <p>Cras mollis orci ac arcu consectetur, quis bibendum leo gravida.</p>
          <p>Vivamus dapibus dolor eu tortor molestie, non pulvinar risus dignissim.</p>
          <p>Aliquam vitae lectus vehicula, euismod ex at, accumsan quam.</p>
          <p>Ut vulputate mauris hendrerit mauris placerat tempus quis eget diam.</p>
          <p>Sed vestibulum lacus eu vehicula finibus.</p>
          <p>Praesent non diam vitae eros congue pretium.</p>
          <p>Nulla tincidunt justo sit amet aliquet porta.</p>
          <p>Nam vel elit vitae diam mattis mattis.</p>
          <p>Phasellus in lacus eget sem tempus elementum.</p>
          <p>Integer gravida diam sit amet massa egestas convallis.</p>
          <p>Vestibulum dignissim odio sit amet sem condimentum, ut pharetra erat bibendum.</p>
          <p>Cras molestie tellus id convallis lobortis.</p>",
      }
    })

    post.titles << Admin::Title.new(name: "Post Excerpt test.", post: post)

    assert post.save, post.errors.full_messages.to_sentence

    html = Nokogiri::HTML(post.compiled_excerpt)

    assert html.css('body > h1').length == 0, html.to_s
    assert html.css('body > p').length > 0, html.to_s
  end

end

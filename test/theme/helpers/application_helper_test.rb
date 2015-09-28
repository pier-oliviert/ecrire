require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def setup
    @view_flow = ActionView::OutputFlow.new
    @controller.action_name = 'index'
  end

  test 'main_tag should inject css classes defined in content_for' do
    content_for(:class, 'super class')
    html = main_tag(class: %w(default)) do
      "Hello World!"
    end

    assert_select node(html), 'main.super.default.class'
  end

  test 'main_tag should have the ID set by default' do
    html = main_tag do
      "Hello World!"
    end

    assert_select node(html), "#TestIndex"
  end

  test 'title_tag should always render the tag' do
    html = title_tag
    assert_select node(html), 'title', 1
  end

  test 'title_tag content should always prioritize content_for' do
    @post = Post.first
    title = "A new title"
    content_for :title, title
    html = title_tag

    assert_select node(html), 'title', title
  end

  test 'title_tag should render the post if content_for(:title) is not set' do
    @post = Post.first
    html = title_tag('yada')

    assert_select node(html), 'title', @post.title.name

  end

  test 'title_tag should render the argument passed if nothing else is set' do
    html = title_tag
    assert_select node(html), 'title', 'Ecrire'

    html = title_tag('Oops')
    assert_select node(html), 'title', 'Oops'
  end


  def node(html)
    Nokogiri::HTML::Document.parse(html)
  end
end

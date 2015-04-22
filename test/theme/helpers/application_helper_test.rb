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

  def node(html)
    Nokogiri::HTML::Document.parse(html)
  end
end

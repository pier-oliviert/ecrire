require 'test_helper'

class Admin::PostsControllerTest < ActionController::TestCase
  attr_reader :manager

  def setup
    proxy = @controller.env['warden'] = @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
    proxy.set_user users(:pothibo)
  end

  test 'Saving a draft should redirect to keep editing the post' do
    post :create, admin_post: {'title' => 'Just a test'}
    record = assigns(:post)
    assert_redirected_to edit_admin_post_path(record)

    put :update, id: record.slug, admin_post: {'content' => 'Something to say'}
    assert_redirected_to edit_admin_post_path(record)
  end

  test 'Saving a published article should return the the real post page' do
    @post = posts(:published)
    put :update, id: @post.slug, admin_post: {'content' => 'Oh em G'}

    assert_redirected_to post_path(@post.published_at.year, I18n.l(@post.published_at, format: '%m'), @post, trailing_slash: true)
  end

  protected

  def manager
    @manager ||= Warden::Manager.new(self)
  end
end


require 'test_helper'

class PostsControllerTest < BaseControllerTest

  test 'pagination settings should be set before calling an action' do get :index
    assert_equal @controller.params[:per_page], 10, "Default pagination should be set at 10 per page"
    assert_equal @controller.params[:page], 1, "Default pagination should be at the first page"
  end

  test 'pagination settings should be overridable' do
    # use string as the the number will be coerced through the request
    per_page = '3'
    page = '2'
    get :index, per_page: per_page, page: page

    assert_equal @controller.params[:per_page], per_page, "per_page param should be customized"

    assert_equal @controller.params[:page], page, "page param should be customized"
  end

  test "redirect if the post isn't published" do
    @post = posts(:draft)
    get :show, year: 2003, month: 1, id: @post.id
    assert_redirected_to :root
  end

  test "redirect if the post doesn't exist" do
    get :show, year: 2003, month: 1, id: -1
    assert_redirected_to :root
  end

  test 'Only published posts should be listed in the index' do
    get :index
    assigns(:posts).each do |post|
      assert post.published?
    end
  end

end

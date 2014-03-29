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



end

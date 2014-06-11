class PostsControllerTest < BaseControllerTest

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
    posts.each do |post|
      assert post.published?
    end
  end

end

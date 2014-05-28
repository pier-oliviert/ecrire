module Admin
  class PostsControllerTest < BaseControllerTest

    def setup
      super
      proxy.set_user users(:pothibo)
    end

    test 'Validations: Error should be shown when missing the title' do
    end

    test 'Create a post' do
      data = {
        title: 'A new published post',
        content: 'Some Blah blah',
        stylesheet: 'h1 {\n  text-align: center;\n }'
      }

      put :create, admin_post: data
      @post = assigns(:post)

      assert_equal data[:title], @post.title
      assert_equal data[:content], @post.content
      assert_equal data[:stylesheet], @post.stylesheet
      assert_equal data[:title].parameterize, @post.slug
    end

    test 'Update a post' do
      data = {
        title: 'A new published post',
        content: 'Some Blah blah',
        stylesheet: 'h1 {\n  text-align: center;\n }'
      }

      put :update, id: posts(:published), admin_post: data
      @post = assigns(:post)

      assert_equal data[:title], @post.title
      assert_equal data[:content], @post.content
      assert_equal data[:stylesheet], @post.stylesheet
      assert_equal posts(:published).slug, @post.slug


      data[:slug] = ""

      put :update, id: posts(:published), admin_post: data
      @post = assigns(:post)

      assert_equal data[:title], @post.title
      assert_equal data[:content], @post.content
      assert_equal data[:stylesheet], @post.stylesheet
      assert_equal @post.title.parameterize, @post.slug
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

    test 'Show draft posts' do
      get :index
      assigns(:posts).each do |post|
        assert !post.published?
      end
    end

    test 'Show published posts' do
      get :index, status: :published
      assigns(:posts).each do |post|
        assert post.published?
      end
    end

    test 'pagination of posts' do
      get :index
      assert_equal assigns(:posts).current_page, 1
      assert assigns(:posts).count <= 10
    end

    test 'customize pagination of posts' do
      per = 1
      page = 2
      get :index, per: per, page: page
      assert_equal assigns(:posts).current_page, page
      assert assigns(:posts).count <= per
    end

  end
end

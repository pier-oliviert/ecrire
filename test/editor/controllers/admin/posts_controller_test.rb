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

      put :create, post: data
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

      put :update, id: posts(:published).id, post: data
      @post = assigns(:post)

      assert_equal data[:title], @post.title
      assert_equal data[:content], @post.content
      assert_equal data[:stylesheet], @post.stylesheet
      assert_equal posts(:published).slug, @post.slug


      data[:slug] = ""

      put :update, id: posts(:published).id, post: data
      @post = assigns(:post)

      assert_equal data[:title], @post.title
      assert_equal data[:content], @post.content
      assert_equal data[:stylesheet], @post.stylesheet
      assert_equal @post.title.parameterize, @post.slug
    end

    test 'Saving a post should redirect to keep editing the post' do
      post :create, post: {'title' => 'Just a test'}
      record = assigns(:post)
      assert_redirected_to edit_admin_post_path(record.id)

      put :update, id: record.id, post: {'content' => 'Something to say'}
      assert_redirected_to edit_admin_post_path(record.id)
    end

    test 'Saving a published article should redirect to the post edit' do
      @post = posts(:published)
      put :update, id: @post.id, post: {'content' => 'Oh em G'}

      assert_redirected_to edit_admin_post_path(@post.id)
    end

    test 'Publishing redirects to the blog post' do
      data = {
        title: 'A new published post',
        content: 'Some Blah blah',
        stylesheet: 'h1 {\n  text-align: center;\n }'
      }
      put :update, id: posts(:published).id, post: data, button: 'publish'
      assert assigns(:post).published?
      assert_redirected_to post_path(assigns(:post).published_at.year, assigns(:post).published_at.month, assigns(:post).slug)
    end

    test 'Show draft posts' do
      xhr :get, :index
      assigns(:posts).each do |post|
        assert !post.published?
      end
    end

  end
end

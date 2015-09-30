module Admin
  class PostsController < Admin::ApplicationController
    before_action :fetch_post, only: [:show, :edit, :update]
    helper_method :search_posts_params

    def new
      @post = Admin::Post.new
    end

    def index
      posts = Admin::Post

      posts = posts.search search_posts_params
      @posts = posts.order('posts.created_at DESC').includes(:titles)

      respond_to do |format|
        format.html
        format.js
      end
    end

    def drafts
      posts = Admin::Post.drafted

      posts = posts.search search_posts_params
      @posts = posts.order('posts.created_at DESC').includes(:titles)

      render 'index'
    end

    def published
      posts = Admin::Post.published

      posts = posts.search search_posts_params
      @posts = posts.order('posts.published_at DESC').includes(:titles)
      render 'index'
    end

    def create
      @post = Admin::Post.create(title: title_params[:title])

      if @post.errors.any?
        render 'new' and return
      end

      redirect_to url('/admin/posts/:post.id/edit', post: @post)
    end

    def destroy
      post = Admin::Post.find(params[:id])
      post.destroy
      redirect_to :root
    end

    def edit
    end

    def update
      @post.update!(post_params)
      respond_to do |format|
        format.js
      end
    end

    def show
      respond_to do |format|
        format.html do
          render layout: false if request.xhr?
        end
      end
    end

    def toggle
      @post = Admin::Post.find(params[:post_id])
      if @post.published?
        @post.unpublish!
      else
        @post.publish!
      end

      respond_to do |format|
        format.js
      end
    end

    protected

    def search_posts_params
      params.require(:posts).permit(:title, :tag)
    rescue ActionController::ParameterMissing
      {
        status: 'all'
      }
    end

    def title_params
      params.require(:post).permit(:title)
    end

    def post_params
      params.require(:post).permit(:content, :status, :stylesheet, :javascript, :slug)
    end

    def fetch_post
      @post = Admin::Post.find(params[:id])
    end

  end
end

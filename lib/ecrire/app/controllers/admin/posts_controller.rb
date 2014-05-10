module Admin
  class PostsController < Admin::ApplicationController
    before_action :fetch_post, only: [:show, :edit, :update]

    def index
      params[:status] ||= "drafted"
      @posts = Admin::Post.status params[:status]
      @posts = @posts.order('posts.published_at DESC')
      @posts = @posts.page(params[:page]).per(params[:per_page])
      respond_to do |format|
        format.html
      end
    end

    def create
      @post = Admin::Post.create post_params

      respond_to do |format|
        format.html do
          if @post.errors.blank?
            redirect_to edit_admin_post_path(@post)
          end
        end
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        flash[:notice] = t(".successful", title: @post.title)
        if @post.published?
          redirect_to post_path(@post.published_at.year, l(@post.published_at, format: '%m'), @post, trailing_slash: true)
        else
          redirect_to edit_admin_post_path(@post)
        end
      end
    end

    def show
      respond_to do |format|
        format.html do
          render layout: false if request.xhr?
        end
      end
    end

    protected


    def post_params
      params.require(:admin_post).permit(:title, :content, :status, :stylesheet, :javascript, :slug)
    end

    def fetch_post
      @post = Admin::Post.find_by_slug(params[:id])
    end
  end
end

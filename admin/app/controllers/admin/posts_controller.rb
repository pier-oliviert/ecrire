module Admin
  class PostsController < Admin::ApplicationController
    before_action :pagination
    before_action :fetch_post, only: [:show, :edit, :update]

    def index
      params[:status] ||= "drafted"
      @posts = Post.status params[:status]
      @posts = @posts.page(params[:page]).per(params[:per_page])
    end

    def create
      @post = Post.create post_params

      respond_to do |format|
        format.html do
          if @post.errors.blank?
            redirect_to root_url
          end
        end
      end

    end

    def edit
    end

    def update
      @post.update_attributes post_params
      if @post.errors.blank?
        redirect_to :posts
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

    def pagination
      params[:per_page] ||= 10
      params[:page] ||= 1
    end

    def post_params
      params.require(:post).permit(:title, :content, :status, :stylesheet, :slug)
    end

    def fetch_post
      @post = Post.find_by_slug(params[:id])
    end
  end
end

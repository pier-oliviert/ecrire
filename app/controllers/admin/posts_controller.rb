module Admin
  class PostsController < Admin::ApplicationController
    before_action :fetch_post, only: [:show, :edit, :update]

    def index
      params[:status] ||= "drafted"
      @posts = Admin::Post.status params[:status]
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
        flash[:notice] = t(".successful", title: @post.title)
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


    def post_params
      params.require(:post).permit(:title, :content, :status, :stylesheet, :slug)
    end

    def fetch_post
      @post = Admin::Post.find_by_slug(params[:id])
    end
  end
end

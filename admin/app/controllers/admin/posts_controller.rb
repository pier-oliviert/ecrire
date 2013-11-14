module Admin
  class PostsController < Admin::ApplicationController
    before_action :pagination

    def index
      @posts = Post.page(params[:page]).per(params[:per_page])
      if params.has_key? :status
        @posts = @posts.status params[:status]
      end
    end

    def create
      @post = Post.new post_params
      unless @post.save
        # Errors!
        puts @post.errors.full_messages
      end

      if @post.draft?
        redirect_to :back
      else
        redirect_to root_url
      end
    end

    def edit
      @post = Post.find_by_slug(params[:id])
    end

    def update
    end

    protected

    def pagination
      params[:per_page] ||= 10
      params[:page] ||= 1
    end

    def post_params
      params.require(:post).permit(:title, :content, :status, :stylesheet, :slug)
    end
  end
end

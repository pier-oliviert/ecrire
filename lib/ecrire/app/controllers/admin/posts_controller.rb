module Admin
  class PostsController < Admin::ApplicationController
    before_action :fetch_post, only: [:show, :edit, :update]

    def new
      @post = Admin::Post.new
    end

    def index
      @posts = Admin::Post

      if params.has_key?(:q) && !params[:q].blank?
        @titles = Admin::Title.search_by_name(params[:q])
        @posts = @posts.where('id in (?)', @titles.pluck(:post_id).uniq.compact)
      end

      if params.has_key?(:tid) && !params[:tid].blank?
        @posts = @posts.where('? = ANY(posts.tags)', params[:tid])
      end

      @posts = @posts.order('posts.created_at').includes(:titles)

      respond_to do |format|
        format.html
        format.js
      end
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

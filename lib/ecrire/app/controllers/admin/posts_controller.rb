module Admin
  class PostsController < Admin::ApplicationController
    before_action :fetch_post, only: [:show, :edit, :update]

    def new
      if /new\/title/i =~ request.path
        render 'title' and return
      end
    end

    def index
      params[:type] ||= "drafted"
      @posts = Admin::Post.status params[:type]
      @posts = @posts.order('posts.created_at')
      respond_to do |format|
        format.js
      end
    end

    def create
      @post = Admin::Post.create post_params

      respond_to do |format|
        format.html do
          if @post.errors.blank?
            redirect_to edit_admin_post_path(@post.id)
          end
        end
      end
    end

    def destroy
      post = Admin::Post.find(params[:id])
      post.destroy
      redirect_to :root
    end

    def edit
    end

    def update
      if params.has_key?(:post)
        @post.update!(post_params)
      end
      respond_to do |format|
        format.js do
          render_context and return
        end
        format.html do
          case params[:button]
          when 'publish'
            @post.publish!
            flash[:notice] = t(".successful", title: @post.title)
            redirect_to post_path(@post.published_at.year, @post.published_at.month, @post.slug) and return
          when 'unpublish'
            @post.unpublish!
          end
          redirect_to edit_admin_post_path(@post) and return
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
      params.require(:post).permit(:title, :content, :status, :stylesheet, :javascript, :slug)
    end

    def fetch_post
      @post = Admin::Post.find(params[:id])
    end

    def render_context
      available_contexts = %w(title content)
      if params.has_key?(:context) && available_contexts.include?(params[:context])
        render "admin/posts/update/#{params[:context]}" and return
      else
        render nothing: true
      end
    end
  end
end

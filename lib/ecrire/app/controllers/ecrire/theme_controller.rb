module Ecrire
  class ThemeController < ::ApplicationController

    before_action :pagination, only: :index
    protect_from_forgery except: :index

    helper_method :post, :posts

    def index
      respond_to do |format|
        format.html
        format.rss
        format.json do
          headers['Access-Control-Allow-Origin'] = '*'
        end
      end
    end

    def show
      redirect_to :root and return if post.nil?
      redirect_to :root and return unless post.published?
      if post.titles.first != @title
        redirect_to post_path(post), status: :moved_permanently
      end
    end

    protected

    def posts
      @posts ||= Post.published.page(params[:page]).per(params[:per]).order('published_at DESC')
    end

    def post
      @title ||= Title.find_by_slug(params[:id])
      @post ||= @title.post
    end

    def pagination
      params[:per] ||= 10
      params[:page] ||= 1
    end
  end
end

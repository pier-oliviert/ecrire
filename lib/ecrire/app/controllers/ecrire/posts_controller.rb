module Ecrire
  class PostsController < ::ApplicationController
    # TODO: This should be included. I have no idea why this isn't.
    # It actually is loaded in dev as soon as the reloader reloads the files
    include Rails.application.routes.url_helpers

    before_action :pagination, only: :index
    protect_from_forgery except: :index

    helper_method :post

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
    end

    protected

    def posts
      @post ||= Post.published.order(:published_at)
    end

    def post
      @post ||= Post.find_by_slug(params[:id])
    end

    def pagination
      params[:per_page] ||= 10
      params[:page] ||= 1
    end
  end
end

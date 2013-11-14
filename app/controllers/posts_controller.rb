class PostsController < ApplicationController
  before_action :pagination, only: :index

  def index
    @posts = Post.published.page(params[:page]).per(params[:per_page])
  end

  def show
    @post = Post.find_by_slug(params[:id])
    redirect_to :root unless @post.published?
  end

  protected

  def pagination
    params[:per_page] ||= 10
    params[:page] ||= 1
  end
end

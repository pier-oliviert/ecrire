class Admin::ImagesController < ApplicationController
  def index
    @images = post.images
    respond_to do |format|
      format.js
    end
  end

  def create
    @image = post.images.build
    @image.file = params[:file]
    respond_to do |format|
      format.js do
        render 'error' unless @image.save
      end
    end
  end

  protected

  def post
    @post ||= Admin::Post.find_by_slug(params[:post_id])
  end

end

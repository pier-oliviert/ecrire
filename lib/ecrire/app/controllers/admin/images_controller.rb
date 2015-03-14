module Admin
  class ImagesController < Admin::ApplicationController
    def index
      @images = post.images
      respond_to do |format|
        format.js
      end
    end

    def create
      @image = post.header || post.build_header

      unless @image.update(image_params)
        render 'errors', status: 500
      end
    end

    def destroy
      @image = post.header
      @image.clear!
    end

    protected

    def post
      @post ||= Admin::Post.find(params[:post_id])
    end

    def image_params
      params.require(:image).permit(:file)
    end

  end
end

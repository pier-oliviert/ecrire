module Admin
  class ImagesController < Admin::ApplicationController
    def index
      @images = post.images
      respond_to do |format|
        format.js
      end
    end

    def update
      @image = post.header
      if @image.update(image_params)
        @image.touch
      else
        render 'errors'
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

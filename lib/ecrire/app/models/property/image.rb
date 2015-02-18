module Property
  class Image
    attr_accessor :post

    def name
      "image"
    end

    def create(params)
      unless post.header.nil?
        post.header.destroy
      end
      img = post.images.build
      img.file = params[:admin_image][:file]
      img.save
      post.header = img
      post.save
    end

    # TODO:
    # 3. Remove id in post properties
    def destroy(value)
      return if post.header.nil?
      img = post.header
      img.destroy
    end

  end
end


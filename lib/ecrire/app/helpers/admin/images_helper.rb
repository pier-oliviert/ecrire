module Admin
  module ImagesHelper
    def editor_image_tag(post)
      return unless post.header?
      content_tag :div, class: %w(image), style: "background-image: url('#{post.header.url}')" do
        button_to "Remove this image",
          admin_post_properties_path(post.id),
          method: :delete,
          remote: true,
          params: {
            property: 'image'
          },
          data: {confirm: 'Are you sure you want to destroy this image?'}
      end
    end

    def images_config_title
      if @s3 && @s3.errors.any?
        content_tag :h1, class: %w(error) do
          @s3.errors.messages.values.flatten.to_sentence
        end
      else
        content_tag :h1 do
          t('admin.images.helper.title')
        end
      end
    end
  end
end

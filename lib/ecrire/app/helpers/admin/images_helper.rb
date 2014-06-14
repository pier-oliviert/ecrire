module Admin
  module ImagesHelper
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

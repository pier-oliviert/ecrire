module Admin
  class ImageDecorator < Cubisme::Decorator::Base
    def thumbnail(options)
      content_tag :li, class: %w(image), id: "image-#{record.id}" do
        [
          sidebar,
          image,
        ].join.html_safe
      end
    end

    protected

    def image
      content_tag :div,
        nil,
        style: "background-image: url(#{record.url});",
        draggable: true,
        'data-url' => record.url,
        'data-alt' => record.key,
        ondragstart: "window.Editor.imageImporter.configureEvent(event)"
    end

    def sidebar
      content_tag :sidebar, class: %w(options) do
        [
          favorite_button,
          destroy_button,
        ].join.html_safe
      end
    end

    def destroy_button
      link_to '&#59177;'.html_safe,
      admin_image_path(record),
        class: %w(destroy action image),
        'data-token' => form_authenticity_token
    end

    def favorite_button
      css = %w(favorite action image)
      css << 'active' if record.favorite?

      path = admin_image_path(record)

      link_to '&#9733;'.html_safe, path,
        remote: true,
        class: css,
        'data-token' => form_authenticity_token,
        'data-favorite' => !record.favorite?
    end

  end
end

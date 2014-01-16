module Admin
  class ImageDecorator < Cubisme::Decorator::Base
    def thumbnail(options)
      content_tag :li,
        nil,
        draggable: true,
        style: "background-image: url('#{record.url}')",
        'data-url' => record.url,
        'data-alt' => record.key,
        ondragstart: "window.Editor.imageImporter.configureEvent(event)"
    end
  end
end

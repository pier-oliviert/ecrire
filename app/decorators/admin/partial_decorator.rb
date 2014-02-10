module Admin
  class PartialDecorator < Cubisme::Decorator::Base
    def overview(options)
      content_tag :li, class: %w(partial item) do
        link_to record.title, edit_admin_partial_path(record)
      end
    end

    def listing(options)
      content_tag :li,
        title,
        class: %w(partial),
        draggable: true,
        'data-url' => partial_path(record),
        ondragstart: "window.Editor.partialImporter.configureEvent(event)"
    end

    def title
      content_tag :h3, record.title
    end
  end
end

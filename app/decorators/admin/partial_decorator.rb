module Admin
  class PartialDecorator < Cubisme::Decorator::Base
    def overview(options)
      content_tag :li, class: %w(partial) do
        link_to record.title, edit_admin_partial_path(record)
      end
    end

    def listing(options)
      content_tag :li, class: %w(partial) do
        [
          content_tag(:h4, record.title, class: %w(title)),
          content_tag(:span, class: %w(include tag)) do
            "<link rel='partial' href='/partials/#{record.id}' />"
          end
        ].join.html_safe
      end
    end
  end
end

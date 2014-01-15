module Admin
  class PostDecorator < Cubisme::Decorator::Base
    def overview(options)
      html_class = options.fetch :html_class, %w(post item)

      content_tag :li, class: html_class do
        [
          title,
          date
        ].join.html_safe
      end
    end

    private

    def title
      content_tag :h2, class: %w(title) do
        link_to record.title, edit_admin_post_path(record)
      end
    end

    def date
      content_tag :span, class: %w(date) do
        if record.draft?
          l(record.updated_at.to_date, format: date_format)
        else
          l(record.published_at.to_date, format: date_format)
        end
      end
    end

    def date_format
      "%A, %e %B %Y"
    end

  end
end


require_relative '../ecrire_decorator'

module Admin
  class PostDecorator < EcrireDecorator
    def overview(options)
      html_class = options.fetch :html_class, %w(post item)

      content_tag :li, class: html_class do
        title
      end
    end

    private

    def title
      link_to record.title, edit_admin_post_path(record.id)
    end

  end
end

module Admin
  module ApplicationHelper
    def admin_navigation_options
      content_tag :div, id: 'adminNavigationOptions' do
        [
          post_link
        ].join.html_safe
      end
    end

    private

    def post_link
      html_class = %w(link)
      if controller.kind_of? Admin::PostsController
        html_class << "active"
      end

      [
        link_to(t(".links.post"), posts_path, class: html_class),
        link_to(t(".links.partials"), partials_path, class: html_class)
      ].join.html_safe
    end
  end
end

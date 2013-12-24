module Admin
  module PostsHelper
    def filter_links
      content_tag :div, class: %w(filters) do
        [
          link_published_post(!drafted_posts?),
          link_drafted_post(drafted_posts?)
        ].join.html_safe
      end
    end

    protected

    def link_published_post(is_active, html_class = %w(filter))
      html_class << "active" if is_active
      link_to "Published", admin_posts_path(status: "published"), class: html_class
    end

    def link_drafted_post(is_active, html_class = %w(filter))
      html_class << "active" if is_active
      link_to "Draft", admin_posts_path(status: "drafted"), class: html_class
    end

    private

    def drafted_posts?
      @drafted ||= params[:status].eql?("drafted")
    end

  end
end

module Admin
  module PostsHelper
    include ::PostsHelper

    def editor_back_button(post)
      if post.published?
        path = post_path(post)
      else
        path = root_path
      end
      link_to "", path, 'data-no-turbolink' => true
    end

    def preview_header(post, options = {}, &block)
      content_tag :header, options do
        if block_given?
          yield
        end
      end
    end
  end
end

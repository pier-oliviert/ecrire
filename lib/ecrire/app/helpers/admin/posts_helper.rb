module Admin
  module PostsHelper
    include ::PostsHelper

    def editor_back_button(post)
      if post.published?
        path = post_path(post)
      else
        path = root_path
      end
      link_to "", path
    end

  end
end

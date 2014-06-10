module Admin
  module PostsHelper
    def post_path(post, options = {})
      if post.published?
        options[:year] = post.published_at.year
        options[:month] = post.published_at.month
      else
        options[:year] = post.created_at.year
        options[:month] = post.created_at.month
      end

      super(post.becomes(::Post), options)
    end

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

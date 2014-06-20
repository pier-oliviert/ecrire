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
      options[:class] ||= []
      options[:class] << 'image' if post.header?

      content_tag :header, options do
        content = [
          image_container(post)
        ]

        if block_given?
          content.append(capture(&block))
        end

        content.join.html_safe
      end
    end

    def image_container(post)
      options = {class: %w(image)}
      if post.header?
        options[:style] = "background-image: url(#{post.header.url});"
      end
      content_tag(:div, nil, options)
    end
  end
end

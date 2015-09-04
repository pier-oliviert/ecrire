module Admin
  module PostsHelper

    def post_tags(post)
      if post.tags.any?
        tags = post.tags.map(&:name).join(', ') << '.'
      else
        tags = 'No tag yet.'
      end

      tags << ' ' << link_to('Change tags', admin_post_tags_path(post), remote: true)
      content_tag :div, tags.html_safe, class: %w(tags), as: 'Post.Tags'
    end

    def edit_content_tag(post)
      content_tag :article, id: 'PostBody', postid: @post.id,
        class: %w(content),
        as: 'Editor.Content',
        contenteditable: true,
        href: admin_post_path(@post.id) do |div|

          if Rails.application.secrets.has_key?(:s3)
            div[:bucket] = Rails.application.secrets.s3['bucket']
            div[:access_key] = Rails.application.secrets.s3['access_key']
            div[:signature] = image_form_signature(image_form_policy(@post))
            div[:policy] = image_form_policy(@post)
            if Rails.application.secrets.s3.has_key?('namespace')
              div['namespace'] = Rails.application.secrets.s3['namespace']
            end
          end

          yield if block_given?
        end
    end
  end
end

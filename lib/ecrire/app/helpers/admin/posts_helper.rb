module Admin
  module PostsHelper
    include ::PostsHelper

    def post_edit_content(post)
      content_tag :div,
        id: 'PostBody',
        postid: @post.id,
        bucket: Rails.application.secrets.s3['bucket'],
        access_key: Rails.application.secrets.s3['access_key'],
        signature: image_form_signature(image_form_policy(@post)),
        policy: image_form_policy(@post),
        class: %w(content),
        as: 'Editor.Content',
        contenteditable: true,
        href: admin_post_path(@post.id) do
          post.content
        end
    end
  end
end

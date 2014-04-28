module PostsHelper
  def admin_edit_link
    return unless signed_in?

    link_to t('en.posts.edit'), edit_admin_post_path(post)
  end
end

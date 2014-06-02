module PostsHelper
  def edit_post_link(options = {})
    return unless signed_in?

    link_to t('posts.edit'), edit_admin_post_path(post), options
  end
end

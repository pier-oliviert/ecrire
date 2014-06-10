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

  def edit_post_link(options = {})
    return unless signed_in?

    link_to t('posts.edit'), edit_admin_post_path(post.id), options
  end
end

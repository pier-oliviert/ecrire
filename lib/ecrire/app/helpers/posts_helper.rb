module PostsHelper
  def post_path(post, options = {})
    year = post.published_at.year
    month = post.published_at.month

    title = options.delete(:title) || post.titles.last

    url_for "/#{[year, month, title.slug].join('/')}"
  end

  def edit_post_link(options = {})
    return unless signed_in?

    link_to t('posts.edit'), edit_admin_post_path(post.id), options
  end
end

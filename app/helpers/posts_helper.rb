module PostsHelper
  def suggested_posts(current_post)
    @posts ||= Post.published.limit(3).order("published_at DESC").without(current_post)
  end
end

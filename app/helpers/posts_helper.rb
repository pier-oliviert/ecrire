module PostsHelper
  def suggested_posts(current_post)
    @posts ||= Post.limit(3).order("published_at DESC").without(current_post)
  end
end

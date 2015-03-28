module PostsHelper
  def edit_post_link(options = {})
    return unless signed_in?

    link_to t('posts.edit'), edit_admin_post_path(post.id), options
  end

  def paginate(scope, options = {}, &block)
    _with_routes Ecrire::Theme::Engine.routes do
      super
    end
  end
end

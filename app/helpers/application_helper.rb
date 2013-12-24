module ApplicationHelper
  def admin_navigation
    content_tag :header, id: 'adminNavigationOptions' do
      [
        link_to(t('admin.navigation.blog'), root_path, id: 'linkHome'),
        post_link,
        button_to(t("admin.navigation.logout"), session_path, method: :delete)
      ].join.html_safe
    end
  end

  def title
    return @post.title unless @post.nil?
    return "pothibo's blog"
  end

  private

  def post_link
    html_class = %w(link)
    if controller.kind_of? Admin::PostsController
      html_class << "active"
    end

    [
      link_to(t("admin.navigation.posts"), admin_posts_path, class: html_class),
      link_to(t("admin.navigation.partials"), admin_partials_path, class: html_class)
    ].join.html_safe
  end

end

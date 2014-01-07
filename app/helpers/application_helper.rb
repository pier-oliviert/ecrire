module ApplicationHelper
  def admin_navigation
    content_tag :header, id: 'adminNavigationOptions' do
      [
        menu.render,
        button_to(t("admin.navigation.logout"), session_path, method: :delete)
      ].join.html_safe
    end
  end

  def title
    return @post.title unless @post.nil?
    return "pothibo's blog"
  end

  def description_meta_tag
    content_tag :meta, nil, name: 'description', content: 'Ruby, Javascript, CSS blog. I use my experience to help you understand different programming concepts.'
  end

end

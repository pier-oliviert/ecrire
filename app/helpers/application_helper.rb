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
    return Rails.configuration.meta.title
  end

  def description_meta_tag
    content_tag :meta, nil, name: 'description', content: Rails.configuration.meta.description
  end

  def open_graph_type
    if @post.nil?
      'website'
    else
      'article'
    end
  end

end

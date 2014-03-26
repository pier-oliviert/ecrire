module ApplicationHelper
  def admin_navigation
    return unless signed_in?

    content_tag :nav, id: 'adminNavigationOptions' do
      [
        menu.render,
        button_to(t("admin.navigation.logout"), session_path, method: :delete)
      ].join.html_safe
    end
  end

  def title_tag
    content_tag :title do
      title
    end
  end

  def title
    if @post.nil?
      Rails.configuration.meta.title
    else
      @post.title
    end
  end

  def assets_tags
    [
      stylesheet_link_tag("application", media: "all", "data-turbolinks-track" => true),
      javascript_include_tag("application", "data-turbolinks-track" => true)
    ].join.html_safe
  end

  def meta_informations_tags
    [
      content_tag(:link, nil, rel: 'alternate', type: 'application/rss+xml', title: 'RSS', href: '/feed'),
      content_tag(:link, nil, rel: %w(shortcut icon), href: '/favicon.ico'),
      content_tag(:link, nil, rel: %w(author), href: Rails.configuration.meta.author),
      csrf_meta_tags,
      description_meta_tag,
      open_graph_tags
    ].join.html_safe
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

  def body_tag(html_options = {})
    content_tag :body, yield, html_options
  end

end

module ApplicationHelper
  def admin_navigation
    return unless signed_in?

    if block_given?
      content = with_output_buffer { yield }
    end

    content_tag :nav, id: 'adminNavigationOptions' do
      [
        menu.render,
        content_tag(:div, content, class: %w(spacer)),
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
    unless @post.nil?
      @post.title
    end
  end

  def assets_tags
    [
      stylesheet_link_tag("application", "base", media: "all", "data-turbolinks-track" => true),
      javascript_include_tag("application", "base", "data-turbolinks-track" => true)
    ].join.html_safe
  end

  def meta_informations_tags
    [
      content_tag(:link, nil, rel: 'alternate', type: 'application/rss+xml', title: 'RSS', href: '/feed'),
      content_tag(:link, nil, rel: %w(shortcut icon), href: '/favicon.ico'),
      csrf_meta_tags
    ].join.html_safe
  end

  def description_meta_tag
    content_tag :meta, nil, name: 'description', content: Rails.application.secrets.meta['description']
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


  def flash_messages
    return if flash.empty?

    flash.map do |name, msg|
      content_tag :div, class: %W(flash #{name}) do
        content_tag(:span, h(msg), class: %w(message))
      end
    end.join.html_safe
  end

end

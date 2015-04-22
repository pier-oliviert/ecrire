module ApplicationHelper
  def admin_navigation
    return unless signed_in?
    render 'sessions/navigation'
  end

  def title_tag(title = 'Ecrire')
    content_tag :title do
      if block_given?
        yield
      elsif !@post.nil?
        @post.title
      else
        title
      end
    end
  end

  def meta_informations_tags
    [
      content_tag(:link, nil, rel: 'alternate', type: 'application/rss+xml', title: 'RSS', href: '/feed'),
      content_tag(:link, nil, rel: %w(shortcut icon), href: asset_url('favicon.ico')),
      csrf_meta_tags
    ].join.html_safe
  end

  def description_meta_tag
    if Rails.application.secrets.fetch(:meta, {}).has_key?(:description)
      content_tag :meta, nil, name: 'description', content: Rails.application.secrets[:meta][:description]
    end
  end

  def open_graph_type
    if @post.nil?
      'website'
    else
      'article'
    end
  end

  def main_tag(html_options = {}, &block)
    html_options[:id] ||= [controller_name, action_name].map(&:capitalize).join
    html_options[:class] = [html_options[:class]].compact.flatten
    if content_for?(:class)
      html_options[:class].concat content_for(:class).split(' ')
    end
    content_tag :main, html_options, &block
  end

end

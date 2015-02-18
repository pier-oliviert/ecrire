module OpenGraphHelper
  # OpenGraph is in meta tags. First I thought it would bring problem if meta tags wouldn't change between page load.
  # Thinking it through, it doesn't matter if open graph tags aren't changed between pages as it's needed by crawler that does full page load
  # So the tags will always match the content.
  # I doubt this will change in the future as turbolinks checks for crawlers and disable itself when it meets one.
  #

  def open_graph_tags
    if @post.nil?
      og_website
    else
      og_article(@post)
    end
  end

  protected

  def og_website
    [
      og_title,
      og_type('website')
    ].join.html_safe
  end

  def og_article(post)
    raise OGNoArticleError if post.nil?
    [
      og_title,
      og_type('article'),
      content_tag(:meta, nil, property: 'og:article:published_time', content: post.published_at.iso8601)
    ].join.html_safe

  end

  def og_type(value)
    content_tag :meta, nil, property: 'og:type', content: value
  end

  def og_title
    content_tag :meta, nil, property: 'og:title', content: title
  end

  class OGNoArticleError < StandardError; end

end

class PostDecorator < EcrireDecorator
  def list(options)
    content_tag_for :li, record do
      [
        content_tag(:span, l(record.published_at.to_date, format: :short)),
        '&mdash;',
        link_to(record.title, post_path(record))
      ].join.html_safe
    end
  end

  def content(options)
    [
      stylesheet,
      javascript,
      record.content.html_safe
    ].join.html_safe
  end

  def stylesheet
    return if record.stylesheet.nil?
    content_tag(:style, record.stylesheet, scoped: true)
  end

  def javascript
    return if record.javascript.nil?
    content_tag(:script, record.javascript, async: true)
  end

end

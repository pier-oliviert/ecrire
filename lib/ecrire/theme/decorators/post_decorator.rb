class PostDecorator < EcrireDecorator
  def suggested(options)
    content_tag :li do
      content = [
        link_to(record.title,
                post_path(year: record.published_at.year,
                          month: l(record.published_at, format: "%m"),
                          id: record.slug, only_path: false))
      ]
      if options[:excerpt] == true
        content << content_tag(:p, record.excerpt, class: %w(excerpt))
      end
      content.join.html_safe
    end
  end
end


class PostDecorator < Cubisme::Decorator::Base
  def suggested(options)
    content_tag :li do
      link_to record.title, post_path(year: record.published_at.year, month: l(record.published_at, format: "%m"), id: record.slug, bouncing: true, only_path: false)
    end
  end
end

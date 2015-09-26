module Admin
  module TagsHelper
    def posts_by_tag(posts, status)
      str = "#{posts.count} #{status} post"
      if posts.count > 1
        str << 's'
      end

      str
    end
  end
end


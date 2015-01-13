require 'kramdown'

module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image

    def publish!(params = {})
      self.assign_attributes(params)
      self.published_at = DateTime.now
      self.save!
    end

    def unpublish!(params = {})
      self.assign_attributes(params)
      self.published_at = nil
      self.save!
    end

    def stylesheet
      super || ""
    end

    def javascript
      super || ""
    end

    def content
      super || ""
    end

  end
end

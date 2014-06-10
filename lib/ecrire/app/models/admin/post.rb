module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image

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

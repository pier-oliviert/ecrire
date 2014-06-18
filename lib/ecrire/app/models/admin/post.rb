module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image
    has_many :labels, class_name: Admin::Label

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

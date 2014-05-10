module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image

    def slug
      id
    end
  end
end

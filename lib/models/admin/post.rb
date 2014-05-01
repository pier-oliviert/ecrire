module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image
  end
end

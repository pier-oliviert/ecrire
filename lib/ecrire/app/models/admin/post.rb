require 'kramdown'

module Admin
  class Post < ::Post
    has_many :images, class_name: Admin::Image
    before_save :compile!

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
      read_attribute(:content) || ""
    end

    private

    def compile!
      self.compiled_content = Kramdown::Document.new(self.content).to_html
      html = Nokogiri::HTML(self.compiled_content).xpath("//body").children[0..20]
      self.compiled_excerpt = html.to_s
    end
  end
end

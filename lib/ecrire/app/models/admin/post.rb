require 'kramdown'

module Admin
  class Post < ::Post
    has_one :header, class_name: Admin::Image
    before_save :compile!, prepend: true
    before_save :excerptize!

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

    def header
      begin
        header = super
        if header.nil?
          header = Admin::Image.create(post: self)
        end
        header
      end
    end

    def content
      read_attribute(:content) || ""
    end

    private

    def compile!
      self.compiled_content = Kramdown::Document.new(self.content).to_html
    end

    def excerptize!
      html = Nokogiri::HTML(self.compiled_content).css("body > p")
      html = html[0..20].filter(":not(img)")
      self.compiled_excerpt = html.join(&:to_html)
    end

  end
end

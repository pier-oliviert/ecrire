require 'kramdown'

module Admin
  class Post < ::Post

    has_one :header, class_name: Admin::Image
    has_many :titles

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

    def content
      read_attribute(:content) || ""
    end

    private

    def compile!
      self.compiled_content = Kramdown::Document.new(self.content).to_html
    end

    def excerptize!
      html = Nokogiri::HTML(self.compiled_content)
      html.xpath("//img").each do |img|
        img.remove
      end
      self.compiled_excerpt = html.xpath('//body').children[0..20].to_s
    end

  end
end

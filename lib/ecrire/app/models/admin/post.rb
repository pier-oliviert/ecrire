module Admin
  class Post < ::Post

    has_one :header, class_name: Admin::Image
    has_many :titles, -> { order "titles.created_at DESC" }, class_name: Admin::Title

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
      self.compiled_content = Ecrire::Markdown.parse(self.content).to_html
    end

    def excerptize!
      html = Nokogiri::HTML(self.compiled_content)
      html.xpath("//img").each do |img|
        img.remove
      end

      valid_elements = %w(p ul ol li).freeze

      elements = html.xpath('//body').children[0..19].take_while do |el|
        valid_elements.include?(el.name)
      end

      self.compiled_excerpt = elements.map(&:to_s).join
    end

  end
end

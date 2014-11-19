module ContentTagHelper
  def content_tag(*args)
    if block_given?
      tag = Tag.new(args[0], args[1] || {})
      old_buf = @output_buffer
      @output_buffer = ActionView::OutputBuffer.new
      value = yield(tag)
      content = tag.render(@output_buffer.presence || value || '')
      @output_buffer = old_buf
      content
    else
      super
    end
  end

  class Tag
    include ActionView::Helpers::CaptureHelper
    attr_accessor :id
    attr_reader :name, :css

    def initialize(name, attributes = {})
      @name = name
      @attributes = attributes.with_indifferent_access
      @attributes[:class] = Tag::CSS.new(attributes[:class])
    end

    def css
      @attributes[:class]
    end

    def []=(k,v)
      @attributes[k] = v
    end
    
    def render(content)
      "<#{name}#{render_attributes}>#{content.strip}</#{name}>".html_safe
    end

    def render_attributes
      attrs = @attributes.dup
      if css.empty?
        attrs.delete :class
      else
        attrs[:class] = css.to_s
      end

      attrs.keys.map do |k|
        "#{k}='#{attrs[k]}'".html_safe
      end.join.prepend(' ')
    end

    class CSS
      
      def initialize(css)
        if css.is_a? String
          @internals = css.split(' ')
        else
          @internals = css.to_a
        end
      end

      def to_s
        @internals.uniq.join(' ')
      end

      def empty?
        @internals.empty?
      end

      def <<(name)
        @internals << name
        nil
      end
    end
  end
end


module ContentTagHelper
  def content_tag(*args, &block)
    if block_given?
      tag = Tag.new(*args)
      old_buf = @output_buffer
      @output_buffer = ActionView::OutputBuffer.new
      value = yield(tag)
      content = tag.render(@output_buffer.presence || value)
      @output_buffer = old_buf
      content
    else
      super
    end
  end

  private

  class Tag
    include ActionView::Helpers::CaptureHelper
    attr_accessor :id
    attr_reader :name, :css

    def initialize(name, *args)
      @name = name
      @attributes = tag_options(*args)
      @attributes[:class] = Tag::CSS.new(@attributes.fetch(:class, {}))
    end

    def tag_options(*args)
      options = nil
      args.each do |a|
        if a.is_a?(Hash)
          options = a
          break
        end
      end
      (options || {}).with_indifferent_access
    end

    def css
      @attributes[:class]
    end

    def []=(k,v)
      @attributes[k] = v
    end
    
    def render(content)
      "<#{name}#{render_attributes}>#{content.to_s.strip}</#{name}>".html_safe
    end

    def render_attributes
      attrs = @attributes.dup
      if css.empty?
        attrs.delete :class
      else
        attrs[:class] = css.to_s
      end

      attrs.keys.map do |k|
        "#{k}='#{attrs[k]}'"
      end.join(' ').prepend(' ').html_safe
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
        @internals.uniq.join(' ').html_safe
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


module Admin
  module MenuHelper
    class Menu
      include ActionView::Helpers
      include ActionView::Context

      def initialize(request)
        @request = request
        @items = Hash.new.with_indifferent_access
        raise StandardError unless block_given?
        yield self
        @items.freeze
      end

      def add(name, klass = Admin::MenuHelper::Item)
        raise ArgumentError unless block_given?
        raise IndexError if @items.has_key?(name)
        item = klass.new(@request)
        @items[name] = item
        yield item
      end

      def render
        @items.values.map(&:render).join.html_safe
      end
    end

    class Item
      include ActionView::Helpers
      include ActionView::Context
      include Rails.application.routes.url_helpers

      attr_reader :request, :css

      attr_accessor :path, :label, :id

      def initialize(request)
        @request = request
        @css = %w(link)
      end

      def highlight_when(&block)
        raise ArgumentError if block.nil?
        @callback = block
      end

      def render
        raise StandardError, "Admin::MenuHelper::Item is not configured properly, it's missing a callback" if @callback.nil?

        @css << "active" if @callback.call(@request)
        link_to(@label, path, class: @css, id: @id)
      end
    end
  end
end

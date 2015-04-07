module Ecrire::Markdown
  module Nodes
    class OrderedList < Node

      def initialize(text)
        @content = "<li>#{text}</li>"
      end

      def append(text)
        @content << "<li>#{text}</li>"
      end

      def to_s
        "<ol>#{@content}</ol>"
      end
    end
  end
end

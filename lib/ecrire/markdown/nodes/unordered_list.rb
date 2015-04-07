module Ecrire::Markdown
  module Nodes
    class UnorderedList < Node

      def initialize(text)
        @content = "<li>#{text}</li>"
      end

      def append(text)
        @content << "<li>#{text}</li>"
      end

      def to_s
        "<ul>#{@content}</ul>"
      end
    end
  end
end


module Ecrire::Markdown
  module Nodes
    class Heading < Node
      def initialize(size, content)
        @size = size
        @content = content
      end

      def to_s
        "<h#{@size}>#{@content}</h#{@size}>"
      end
    end
  end
end


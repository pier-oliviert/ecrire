module Ecrire::Markdown
  module Nodes
    class Image < Node
      def initialize(title, src)
        @title = title
        @src = src
      end

      def to_s
        "<figure><img src='#{@src}' /><figcaption>#{@title}</figcaption></figure>"
      end
    end
  end
end

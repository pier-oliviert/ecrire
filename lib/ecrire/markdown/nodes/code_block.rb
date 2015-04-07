module Ecrire::Markdown
  module Nodes
    class CodeBlock < Node
      def initialize(language, content)
        @content = content
        @language = language
      end

      def to_s
        "<pre><code language='#{@language}'>#{@content}</code></pre>"
      end
    end
  end
end


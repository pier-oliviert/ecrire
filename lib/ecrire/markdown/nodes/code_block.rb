require 'active_support/core_ext/string'

module Ecrire::Markdown
  module Nodes
    class CodeBlock < Node
      def initialize(language, title, nodes)
        @content = ERB::Util.html_escape(nodes.join("\n"))
        @title = title
        @language = language
      end

      def to_s
        str = "<pre>"
        str << "<header>#{@title}</header>"

        str << "<code"

        unless @language.nil?
          str << " class='language-#{@language}'>"
        end


        str << @content
        str << "</code></pre>"
        str
      end
    end
  end
end


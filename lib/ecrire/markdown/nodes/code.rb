require 'active_support/core_ext/string'

module Ecrire::Markdown
  module Nodes
    class Code < Node

      attr_reader :offset

      attr_accessor :title, :block

      def initialize(data)

        @offset = data.offset(0)[0]
        @language = (data[3] || "").strip

        @content = data[4]

      end

      def block?
        @block == true
      end

      def content=(new_content)
        if new_content.is_a?(Array)
          @content = ERB::Util.html_escape(new_content.join("\n"))
        else
          @content = new_content
        end
      end

      def code_element
        str = "<code"

        unless @language.nil?
          str << " class='language-#{@language}'>"
        end

        str << @content
        str << "</code>"
        str
      end

      def to_s

        str = String.new

        unless @title.nil?
          str << "<header>#{@title}</header>"
        end

        str << code_element

        if block?
          return "<pre>#{str}</pre>"
        else
          return str
        end
      end
    end
  end
end


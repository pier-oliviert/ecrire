require 'ecrire/markdown/parsers'
require 'ecrire/markdown/node'

module Ecrire::Markdown
  class Document

    attr_reader :nodes

    def initialize(content)
      @nodes = content.lines.map do |text|
        Node.new(text.chomp)
      end
    end

    def parsers
      [
        Ecrire::Markdown::Parsers::Code,
        Ecrire::Markdown::Parsers::Heading,
        Ecrire::Markdown::Parsers::Image,
        Ecrire::Markdown::Parsers::List,
        Ecrire::Markdown::Parsers::Word,
        Ecrire::Markdown::Parsers::Link
      ]
    end

    def parse!
      parsers.each do |parser|
        parser.parse!(self)
      end
    end

    def to_html
      @nodes.map do |node|
        if node.instance_of?(Ecrire::Markdown::Node)
          "<p>#{node.to_s}</p>"
        else
          node.to_s
        end
      end.join
    end
  end
end

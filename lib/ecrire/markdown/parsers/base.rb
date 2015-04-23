module Ecrire::Markdown::Parsers
  class Base
    class << self
      private :new
    end

    def self.parse!(document)
      i = 0
      while !document.nodes[i].nil? do
        node = new(document, document.nodes[i], i).parse!
        i = document.nodes.index(node) + 1
      end
    end

    def initialize(document, node, index)
      @document = document
      @node = node
      @index = index
    end

    def parse!
      return @node
    end

  end
end

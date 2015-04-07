module Ecrire::Markdown::Parsers
  class Base
    class << self
      private :new
    end

    attr_reader :node

    def self.parse!(document)
      i = 0
      while !document.nodes[i].nil? do
        node = document.nodes[i]
        new(document, node, i).parse!
        i += 1
      end
    end

    def initialize(document, node, index)
      @document = document
      @node = node
      @index = index
    end

    private

    attr_reader :document, :node, :index

  end
end

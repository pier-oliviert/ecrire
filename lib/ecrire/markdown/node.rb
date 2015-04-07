module Ecrire::Markdown
  module Nodes
    autoload :Image,                   'ecrire/markdown/nodes/image'
    autoload :UnorderedList,           'ecrire/markdown/nodes/unordered_list'
    autoload :OrderedList,             'ecrire/markdown/nodes/ordered_list'
    autoload :CodeBlock,               'ecrire/markdown/nodes/code_block'
    autoload :Heading,                 'ecrire/markdown/nodes/heading'
  end

  class Node
    attr_accessor :content

    def initialize(content)
      @content = content || String.new
    end

    def to_s
      @content
    end
  end
end

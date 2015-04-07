module Ecrire::Markdown::Parsers
  class Heading < Base
    RULE = /^(\#{1,6} )(.+)/i

    def parse!

      unless @node.instance_of?(Ecrire::Markdown::Node)
        return @node
      end

      if match = RULE.match(@node.content)
        size = match[1].length - 1
        @node = Ecrire::Markdown::Nodes::Heading.new(size, match[2])
        @document.nodes[@index] = @node
      end
      return @node
    end
  end
end

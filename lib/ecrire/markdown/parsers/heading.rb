module Ecrire::Markdown::Parsers
  class Heading < Base
    RULE = /^(\#{1,6} )(.+)/i

    def parse!
      if match = RULE.match(node.content)
        size = match[1].length - 1
        document.nodes[index] = Ecrire::Markdown::Nodes::Heading.new(size, match[2])
      end
    end
  end
end

module Ecrire::Markdown::Parsers
  class Image < Base
    RULE = /^(!{1}\[([^\]]+)\])(\(([^\s]+)?\))$/i

    def parse!
      if match = RULE.match(node.content)
        document.nodes[index] = Ecrire::Markdown::Nodes::Image.new(match[2], match[4])
      end
    end
  end
end


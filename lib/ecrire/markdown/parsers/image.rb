module Ecrire::Markdown::Parsers
  class Image < Base
    RULE = /^(!{1}\[([^\]]+)\])(\(([^\s]+)?\))$/i

    def parse!

      unless @node.instance_of?(Ecrire::Markdown::Node)
        return @node
      end

      if match = RULE.match(@node.content)
        @node = Ecrire::Markdown::Nodes::Image.new(match[2], match[4])
        @document.nodes[@index] = @node
      end
      return @node
    end
  end
end


module Ecrire::Markdown::Parsers
  class Link < Base
    RULE = /!{0}(\[([^\]]+)\])(\(([^\)]+)\))/i

    def parse!
      while match = RULE.match(node.content) do
        node.content.gsub! match[0], "<a href='#{match[4]}'>#{match[2]}</a>"
      end
    end
  end
end

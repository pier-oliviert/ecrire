module Ecrire::Markdown::Parsers
  class Word < Base
    RULE = /((\*{1,2})([^\*]+)(\*{1,2}))/i

    def parse!
      while match = RULE.match(node.content) do
        if match[2].length == 1
          node.content.gsub! match[0], "<em>#{match[3]}</em>"
        elsif match[2].length == 2
          node.content.gsub! match[0], "<strong>#{match[3]}</strong>"
        end
      end
    end
  end
end

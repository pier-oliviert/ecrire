module Ecrire::Markdown::Parsers
  class Code < Base
    OPENING_TAG = /^((~{3,})([a-z]+)?)(.+)??/i

    def parse!
      if match = OPENING_TAG.match(@node.content)
        count = match[2].size
        language = match[3]
        nodes = extract_code_nodes!(count)
        @node = Ecrire::Markdown::Nodes::CodeBlock.new(language, nodes.join('\n'))
        @document.nodes[@index] = @node
      end
      return @node
    end

    def extract_code_nodes!(count)
      regex = Regexp.new("^(~{#{count}}$)")
      found_closing_tag = false
      i = @index + 1
      nodes = []

      while !found_closing_tag
        break if @document.nodes[i].nil?
        node = @document.nodes.delete_at(i)
        if regex.match(node.content)
          found_closing_tag = true
        else
          nodes.push node
        end
      end
      nodes
    end

  end
end

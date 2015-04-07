module Ecrire::Markdown::Parsers
  class List < Base
    UL = /^(-\s)(.+)?$/i
    OL = /^(\d+\.\s)(.+)?$/i

    def parse!
      if match = UL.match(node.content)
        list! match, Ecrire::Markdown::Nodes::UnorderedList
      elsif match = OL.match(node.content)
        list! match, Ecrire::Markdown::Nodes::OrderedList
      end
    end

    def list!(match, tag)
      previous_node = document.nodes[index - 1]
      if previous_node.nil? || !previous_node.is_a?(tag)
        document.nodes[index] = tag.new(match[2])
      else
        document.nodes.delete(node)
        previous_node.append(match[2])
      end
    end
  end
end

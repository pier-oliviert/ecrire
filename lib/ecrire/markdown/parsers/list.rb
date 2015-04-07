module Ecrire::Markdown::Parsers
  class List < Base
    UL = /^(-\s)(.+)?$/i
    OL = /^(\d+\.\s)(.+)?$/i

    def parse!
      if match = UL.match(@node.content)
        list! match, Ecrire::Markdown::Nodes::UnorderedList
      elsif match = OL.match(@node.content)
        list! match, Ecrire::Markdown::Nodes::OrderedList
      end
      return @node
    end

    def list!(match, tag)
      previous_node = @document.nodes[@index - 1]
      if previous_node.nil? || !previous_node.instance_of?(tag)
        @node = tag.new(match[2])
        @document.nodes[@index] = @node
      else
        @index -= 1
        @document.nodes.delete(@node)
        previous_node.append(match[2])
        @node = previous_node
      end
    end
  end
end

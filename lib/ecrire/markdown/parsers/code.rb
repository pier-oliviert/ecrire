require 'byebug'

module Ecrire::Markdown::Parsers
  class Code < Base
    OPENING_TAG = /((~{3,})([a-z]+)?)(.+)?/i
    attr_accessor :open, :close

    def parse!

      unless @node.instance_of?(Ecrire::Markdown::Node)
        return @node
      end

      while m = OPENING_TAG.match(@node.content)
        node = Ecrire::Markdown::Nodes::Code.new(m) 
        @node.content.slice!(m.offset(1)[0], m[1].size)
        close(node, m[2].size)
      end

      return @node
    end

    def close(node, tildeCount)
      regex = Regexp.new("(~{#{tildeCount},})", Regexp::IGNORECASE)

      if match = regex.match(node.content)
        @node.content.slice!(node.offset, match.offset(1)[1])
        node.content.slice!(match.offset(0)[0], node.content.length - match.offset(0)[0])
        node.content.lstrip!
        @node.content.insert(node.offset, node.to_s)

      elsif node.offset == 0
        extract_siblings(node, regex)
        @node = node
      end
    end

    def extract_siblings(node, regex)
      i = @index + 1
      nodes = []
      node.title = (node.content || "").strip

      while !(n = @document.nodes[i]).nil?
        match = regex.match(n.content)
        @document.nodes.delete_at(i)
        if match.nil?
          nodes.push n
        else
          break
        end
      end

      node.content = nodes
      node.block = true

      @document.nodes[@index] = node

      return node
    end

  end
end

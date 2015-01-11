Editor.Parsers.push class
  rule: /^(#{1,6}) /i

  constructor: (node, el) ->
    @default = el
    @node = node

  render: =>
    @match = @rule.exec(@node.textContent)

    return @node unless @match?

    header = "<h#{@match[1].length}>".toHTML()

    if header.nodeName == @node.nodeName
      return @node
    else
      header.appendChild(node.cloneNode(true)) for node in Array.prototype.slice.call(@node.childNodes)
      return header


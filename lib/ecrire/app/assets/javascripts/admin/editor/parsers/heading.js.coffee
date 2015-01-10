Parsers.push class
  rule: /^(#{1,6}) /i

  constructor: (node, el) ->
    @default = el
    @node = node

  needUpdate: =>
    @match = @rule.exec(@node.textContent)
    @match? || @node instanceof HTMLHeadingElement

  exec: =>
    if @match?
      header = "<h#{@match[1].length}>".toHTML()
      header.appendChild(node) for node in Array.prototype.slice.call(@node.childNodes)
      header
    else
      @default

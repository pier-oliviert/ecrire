Editor.Parsers.push class
  rules: {
    opening: /^(`{3,})($|\s([a-z]+)?$)/mi
    closing: /`{3,}$/i
  }

  constructor: (node, el) ->
    @el = el
    @nodes = [node]
    @closed = false

  isBlock: ->
    true

  isMatched: =>
    @match = @rules.opening.exec(@nodes[0].textContent)

    if @match?
      if @hasClosingTag(@el)
        return true
      else
        node = @el.nextSibling
        while node? && !@closed
          if @hasClosingTag(node)
            @closed = true

          @nodes.push(node)
          sibling = node.nextSibling
          node.remove()
          node = sibling
        return true
    return false

  hasClosingTag: (node) ->
    @rules.closing.exec(node.textContent)?

  render: =>
    pre = "<pre>".toHTML()
    code = "<code>\n".toHTML()
    if @match[3]?
      code.setAttribute("language", @match[3])
    texts = @nodes.map (n) -> n.textContent
    code.textContent = texts.join("\n")
    pre.appendChild(code)
    pre


Editor.Parsers.push class
  rule: /^((~{3,})\s?([a-z]+)?$)(.+)?(~{3,}$)?/mi

  constructor: (node, el) ->
    @el = el
    @nodes = [node]
    @tildeCount = 0

  isMatched: =>
    @match = @rule.exec(@nodes[0].textContent)
    if @match? && @match[0]?
      @tildeCount = @match[2].length
      @collectSiblingsUntilMatched(@tildeCount, @el)

  collectSiblingsUntilMatched: (count, node) =>
    node = node.nextSibling
    while node
      @nodes.push node
      nextNode = node.nextSibling
      node.remove()

      match = @rule.exec(node.textContent)

      if match? && match[2]? && match[2].length == count
        break
      node = nextNode


  render: =>
    pre = "<pre>".toHTML()
    code = "<code>\n".toHTML()
    if @match[3]?
      code.classList.add("language-#{@match[3]}")
    texts = @nodes.map (n) -> n.textContent
    code.textContent = texts.join("\n")
    pre.appendChild(code)
    pre


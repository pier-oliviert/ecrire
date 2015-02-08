Editor.Parsers.push class
  rule: /^((~{3,})\s?([a-z]+)?$)(.+)?(~{3,}$)?/mi

  constructor: (node) ->
    @nodes = [node]
    @tildeCount = 0

  isMatched: =>
    @match = @rule.exec(@nodes[0].textContent)
    if @match? && @match[0]?
      @tildeCount = @match[2].length
      @collectSiblingsUntilMatched(@tildeCount, @nodes[0])

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
    code = "<code>".toHTML()
    if @match[3]?
      code.classList.add("language-#{@match[3]}")
    texts = @nodes.map (n) -> n.textContent
    code.textContent = texts.join("\n")
    Prism.highlightElement(code)
    pre.appendChild(code)
    pre


Editor.Parsers.Block.push class
  rule: /^(-\s)(.+)?$/i

  constructor: (node) ->
    @nodes = [node]
    @match = @rule.exec(@nodes[0].textContent)

  isMatched: =>
    if @match?
      @collectMatchingSiblings(@nodes[0])

    @match?

  collectMatchingSiblings: (root) =>
    node = root.nextElementSibling
    while node
      sibling = node.nextElementSibling
      m = @rule.exec(node.textContent)
      if m?
        @nodes.push node
        node.remove()
        node = sibling
        continue
      break


  render: =>
    list = "<ul>".toHTML()
    for node in @nodes
      li = '<li>'.toHTML()
      li.textContent = node.textContent
      list.appendChild(li)
    list


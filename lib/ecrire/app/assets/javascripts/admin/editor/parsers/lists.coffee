Editor.Parsers.push class
  rule: /^(-\s)(.+)?$/gi

  constructor: (node) ->
    @nodes = [node]
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

  isMatched: =>
    @match = @rule.exec(@walker.root.textContent)

    if @match?
      @collectMatchingSiblings(@walker.root)

  collectMatchingSiblings: (root) =>
    node = root.nextElementSibling
    while node
      if node.textContent.length == 0
        @nodes.push node
        node.remove()
        break

      m = @rule.exec(node)
      if m?
        @nodes.push node
        node.remove()

      node = node.nextElementSibling


  render: =>
    list = "<ul>".toHTML()
    for node in @nodes
      li = '<li>'.toHTML()
      li.textContent = node.textContent
      list.appendChild(li)
    list


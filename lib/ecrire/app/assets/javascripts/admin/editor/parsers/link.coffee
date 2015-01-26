Editor.Parsers.push class
  rule: /!{0}(\[([^\]]+)\])(\(([^\)]+)\))/gi

  constructor: (node, el) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

  isBlock: ->
    false

  isMatched: =>
    @matches().length > 0

  matches: () =>
    matches = []
    while node = @walker.nextNode()
      while (m = @rule.exec(node.textContent))?
        matches.push m
        if m.index > 0 || m[0].length < node.length
          node = node.splitText(m.index)
          node.splitText(m[0].length)

        m.node = node
        @walker.currentNode = node

    @matches = ->
      matches
    @matches()

  render: =>

    for match in @matches()
      if match.node.parentElement.nodeName == 'A'
        continue

      node = match.node
      el = "<a>".toHTML()
      el.href = match[4]

      name = "<strong>".toHTML()
      url = node.splitText(match[1].length)
      name.textContent = match[1]
      el.appendChild(name)
      el.appendChild(url)
      node.parentElement.replaceChild(el, node)

    @walker.root


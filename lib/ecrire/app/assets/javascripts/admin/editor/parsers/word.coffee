Editor.Parsers.add 'word', class
  rule: /((\*{1,2})[^\*]+(\*{1,2}))/gi

  constructor: (node, el) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

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
    if @matches().length == 0
      return @walker.root

    for match in @matches()
      if match[match.length - 1].length == match[match.length - 2].length
        if match[match.length - 1].length == 2
          @bold(match)
        else
          @italic(match)

    @walker.root
      
  bold: (match) =>
    if match.node.parentElement.nodeName == 'STRONG'
      return
    node = match.node
    el = "<strong>".toHTML()
    node.parentElement.replaceChild(el, node)
    el.appendChild(node)
    el

  italic: (match) =>
    if match.node.parentElement.nodeName == 'EM'
      return
    node = match.node
    el = "<em>".toHTML()
    node.parentElement.replaceChild(el, node)
    el.appendChild(node)
    el


Editor.Parsers.add 'code', class
  rules:
    start: /((~{3,})([a-z]+)?)(.+)?/i

  constructor: (node) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

  isMatched: =>
    @matches().length > 0 

  matches: =>
    matches = []
    while node = @walker.nextNode()
      match = @extract(node)
      if match?
        matches.push match
        @walker.currentNode = match.contentNodes[match.contentNodes.length - 1]

    @matches = ->
      matches
    @matches()

  extract: (node) =>
    match = @rules.start.exec(node.textContent)

    if !match?
      return null

    return @split(match, node)

  split: (match, node) ->
    node = node.splitText(match.index)
    match.contentNodes = [node]

    if match.index > 0
      match.inline = true

    match.node = node
    match.tildeCount = match[2].length
    match.contentNodes.push node.splitText(match.tildeCount)

    if m = @findCloseTag(match.contentNodes[1], match.tildeCount)
      match.contentNodes[1].splitText(m.index + m[0].length)
      match.closeNode = match.contentNodes[match.contentNodes.length - 1]

    if match.closeNode?
      match.inline = true
      return match

    node = @walker.root.nextSibling
    while node

      sibling = node.nextSibling
      node.remove()

      textNode = document.createTextNode('\n' + node.textContent)
      match.contentNodes.push textNode

      if m = @findCloseTag(textNode, match.tildeCount)
        match.closeNode = node
        break

      node = sibling

    return match

  findCloseTag: (node, tildeCount) =>
    rule = new RegExp("(~{#{tildeCount},})", 'i')
    rule.exec(node.textContent)



  render: =>
    root = @walker.root

    for match in @matches()

      code = "<code as='Editor.Code'>".toHTML()
      match.node.parentElement.replaceChild(code, match.node)

      if match.inline?
        parent = match.node.parentElement

      code.appendChild(line) for line in match.contentNodes


      if match[3]?
        code.classList.add("language-#{match[3]}")

      Prism.highlightElement(code)

      if !match.inline?
        pre = "<pre>".toHTML()
        pre.appendChild(code)
        root = pre

    root

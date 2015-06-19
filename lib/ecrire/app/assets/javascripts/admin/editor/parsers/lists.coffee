Editor.Parsers.add 'lists', class
  rules: [
    {
      type: 'ul'
      regex: /^(-\s)(.+)?$/i
    },
    {
      type: 'ol'
      regex: /^(\d+\.)(.+)?$/i
    }
  ]

  constructor: (node) ->
    @nodes = [node]
    for rule in @rules
      m = rule.regex.exec(@nodes[0].textContent)
      if m?
        @match = m
        @type = rule.type
        @rule = rule.regex 

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
    list = "<#{@type}>".toHTML()
    for node in @nodes
      li = '<li>'.toHTML()
      li.textContent = node.textContent
      list.appendChild(li)
    list


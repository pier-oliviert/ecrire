Editor.Parsers.push class
  rule: /^(!{1}\[([^\]]+)\])(\(([^\s]+)?\))$/i

  constructor: (node) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

  isMatched: =>
    @match = @rule.exec(@walker.root.textContent)
    @match?

  render: =>
    @figure = EditorElements.content.querySelector("[as='Editor.Image']").cloneNode(true)

    @caption = @figure.querySelector('figcaption')
    @caption.appendChild document.createTextNode(@match[1])
    @caption.appendChild document.createTextNode(@match[3])
    if @match[4]?
      @caption.setAttribute('name', @match[4])

    return @figure

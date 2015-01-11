Editor.Extensions.push class ClipBoard
  constructor: (editor) ->
    @editor = editor
    @editor.on 'paste', @paste

  paste: (e) =>
    e.preventDefault()
    e.stopPropagation()

    data = e.clipboardData.getData('text/plain')

    texts = data.split('\n').map (text) ->
      document.createTextNode(text)
    return unless texts.length > 0

    _sel = window.getSelection()
    sel = {
      type: _sel.type
    }

    if _sel.anchorNode.compareDocumentPosition(_sel.extentNode) == document.DOCUMENT_POSITION_PRECEDING
      sel.anchorNode = _sel.extentNode
      sel.anchorOffset = _sel.extentOffset
      sel.extentNode = _sel.anchorNode
      sel.extentOffset = _sel.anchorOffset
    else
      sel.anchorNode = _sel.anchorNode
      sel.anchorOffset = _sel.anchorOffset
      sel.extentNode = _sel.extentNode
      sel.extentOffset = _sel.extentOffset

    if sel.anchorNode == @editor.element()
      line = @editor.line()
      @editor.element().appendChild(line)
      sel.anchorNode = sel.extentNode = line

    @editor.observer.hold =>
      if sel.type == 'Range'
        @replace(texts, sel)
      else
        @insert(texts, sel)

  replace: (texts, sel) =>
    
    startingNode = @truncate(sel)

    texts[0].textContent = "#{startingNode.textContent}#{texts[0].textContent}"
    offset = texts[texts.length - 1].length

    if startingNode.nextSibling? && startingNode.nextSibling.length > 0
      texts[texts.length - 1].textContent += startingNode.nextSibling.textContent

    lines = texts.map (text) =>
      @editor.parse(@editor.line(text.textContent))

    node = startingNode.parentElement

    for line in lines
      if lines.indexOf(line) == 0
        node.parentElement.replaceChild(line, node)
        node = line
      else if node.nextElementSibling?
        node.parentElement.insertBefore(line, node.nextElementSibling)
        node = line
      else
        node.parentElement.appendChild(line)

    @editor.positionCursor(lines[lines.length - 1], offset)


  truncate: (sel) =>
    node = sel.extentNode

    lastNode = null

    if node.nodeType == Element.TEXT_NODE
      lastNode = node.splitText(sel.extentOffset)
      lastNode.previousSibling.remove()
      node = lastNode.previousSibling || lastNode.parentElement
    else
      n = node.previousSibling
      node.remove()
      node = n

    if !sel.anchorNode.parentElement?
      return node.childNodes[0]


    while node != sel.anchorNode
      if node.nodeType == Element.ELEMENT_NODE
        previousNode = node.previousSibling
        if previousNode.childNodes.length > 0
          previousNode = previousNode.lastChild

          node.remove()
          node = previousNode
          continue

      previousNode = node.previousSibling || node.parentElement
      node.remove()
      node = previousNode

    if sel.anchorNode.parentElement?
      sel.anchorNode.splitText(sel.anchorOffset).remove()
      if lastNode?
        sel.anchorNode.parentElement.appendChild(lastNode)
    else
      sel.anchorNode = node.childNodes[0]

    sel.anchorNode

  insert: (texts, sel) =>

    node = sel.anchorNode
    str = node.textContent
    node.textContent = str.substr(0, sel.anchorOffset)
    node.textContent += texts[0].textContent 
    node.textContent += str.substr(sel.anchorOffset)

    if texts.length > 1
      offset = texts[texts.length - 1].length
    else
      offset = sel.anchorOffset + texts[0].length
    
    while node.parentElement != @editor.element()
      node = node.parentElement

    texts[0].textContent = node.textContent

    lines = texts.map (text) =>
      @editor.parse(@editor.line(text.textContent))


    for line in lines
      if lines.indexOf(line) == 0
        node.parentElement.replaceChild(line, node)
        node = line
      else if node.nextElementSibling?
        node.parentElement.insertBefore(line, node.nextElementSibling)
        node = line
      else
        node.parentElement.appendChild(line)
    
    @editor.positionCursor(lines[lines.length - 1], offset)



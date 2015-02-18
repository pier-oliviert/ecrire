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
    position = _sel.anchorNode.compareDocumentPosition(_sel.extentNode)
    if _sel.anchorOffset <= _sel.extentOffset || position == document.DOCUMENT_POSITION_PRECEDING
      sel.anchorNode = _sel.anchorNode
      sel.anchorOffset = _sel.anchorOffset
      sel.extentNode = _sel.extentNode
      sel.extentOffset = _sel.extentOffset
    else
      sel.anchorNode = _sel.extentNode
      sel.anchorOffset = _sel.extentOffset
      sel.extentNode = _sel.anchorNode
      sel.extentOffset = _sel.anchorOffset

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
    
    node = sel.extentNode
    line = node
    nodes = [node]

    while line.parentElement != @editor.element()
      line = line.parentElement

    offsets = {
      start: sel.anchorOffset
      end: sel.extentOffset
    }

    offsets.start = @editor.lineOffset(line, sel.anchorNode, offsets.start)
    offsets.end = @editor.lineOffset(line, sel.extentNode, offsets.end)

    text = texts.map((t) ->
      t.textContent
    ).join()

    
    line.textContent = line.textContent.substr(0, offsets.start) + text + line.textContent.substr(offsets.end)

    fragment = @editor.parse(@editor.cloneNodesFrom(line))

    @editor.updateDOM(line, fragment)

    @editor.setCursorAt(line, offsets.start + text.length)


  insert: (texts, sel) =>

    node = sel.anchorNode
    str = node.textContent
    text = texts.map((t) ->
      t.textContent
    ).join("\n")

    node.textContent = str.substr(0, sel.anchorOffset)
    node.textContent += text
    node.textContent += str.substr(sel.anchorOffset)

    offset = sel.anchorOffset + text.length
    
    while node.parentElement != @editor.element()
      node = node.parentElement

    fragment = @editor.parse(@editor.cloneNodesFrom(node))

    lines = @editor.updateDOM(node, fragment)

    @editor.setCursorAt(lines[0], offset)



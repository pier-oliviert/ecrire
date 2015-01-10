@Parsers = []

Joint.bind 'Editor.Content', class
  loaded: =>
    @on 'keydown', @linefeed
    @on 'paste', @paste

    @observer = new MutationObserver(@outdated);
    observerSettings = {
      childList: true,
      subtree: true,
      characterData: true
    }

    @observer.observe @element(), observerSettings

    @observer.hold = (cb) =>
      @observer.disconnect()
      cb()
      @observer.observe @element(), observerSettings


  paste: (e) =>
    e.preventDefault()
    e.stopPropagation()

    data = e.clipboardData.getData('text/plain')

    texts = data.split('\n')
    return unless texts.length > 0

    sel = window.getSelection()

    @observer.hold =>
      node = sel.focusNode

      if sel.focusNode == @element()
        node = @line()
        @element().appendChild(node)
      else if node.nodeType == node.TEXT_NODE
        node = node.parentElement


      texts[0] = node.textContent + texts[0]

      lines = texts.map (text) =>
        @parse(@line(text))


      for line in lines
        if lines.indexOf(line) == 0
          node.parentElement.replaceChild(line, node)
          node = line
        else if node.nextElementSibling?
          node.parentElement.insertBefore(line, node.nextElementSibling)
          node = line
        else
          node.parentElement.appendChild(line)

      selectEl = lines[lines.length - 1]
      @positionCursor(selectEl, selectEl.textContent.length)

  outdated: (mutations) =>
    @observer.hold =>
      for mutation in mutations
        @appended node for node in mutation.addedNodes
        @removed node for node in mutation.removedNodes
        if mutation.type == 'characterData'
          @update mutation.target


  linefeed: (e) =>
    return unless e.which == 13

    e.preventDefault()
    e.stopPropagation()

    @observer.hold =>
      sel = window.getSelection()
      line = sel.focusNode
      offset = sel.focusOffset

      while line? && line.parentElement != @element()
        line = line.parentElement

      lines = [
        @line(line.textContent),
        @line()
      ]

      walker = document.createTreeWalker(line, NodeFilter.SHOW_TEXT) 
      while walker.nextNode()
        node = walker.currentNode
        if node == sel.focusNode
          break
        else
          offset += node.length


      if lines[0].childNodes.length > 0
        lines[0].childNodes[0].splitText(offset)
        lines[1].appendChild(lines[0].lastChild)

      @element().replaceChild(lines[0], line)

      if @element().lastChild == lines[0]
        @element().appendChild(lines[1])
      else
        @element().insertBefore(lines[1], lines[0].nextSibling)


      for line in lines
        line.parentElement.replaceChild(@parse(line), line)

      @positionCursor(lines[1], 0)

  update: (node) ->
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    sel = window.getSelection()
    offset = node.textContent.indexOf(sel.focusNode.textContent) + sel.focusOffset

    el = @parse(node)
    if el != node
      node.parentElement.replaceChild(el, node)

    @positionCursor(el, offset)


  removed: (node) =>
    if node.nodeType != 1 || (node instanceof HTMLBRElement && node.parentElement?)
      node.remove()
      return


  appended: (node) =>
    if node instanceof HTMLBRElement
      node.remove()
      return

    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT) 
    line = @parse(@line(node.textContent))
    offset = window.getSelection().focusOffset

    if line.nodeType == node.nodeType && line.innerHTML == node.innerHTML
      return

    node.parentElement.replaceChild line, node

    @positionCursor(line, offset)


  positionCursor: (el, offset) ->
    walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT) 
    idx = 0
    sel = window.getSelection()
    range = document.createRange()

    while node = walker.nextNode()

      idx += node.length
      if offset <= idx
        range.setStart(node, node.length - (idx - offset))
        break


    if range.startContainer == document
      range.setStart(el, 0)

    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)

  line: (text) =>
   cached = "<span class='line'></span>".toHTML()
   @line = (text) ->
     el = cached.cloneNode(true)
     if text?
       el.textContent = text

     el

    @line(text)

  parse: (node) ->
    node.innerHTML = node.textContent
    line = @line()
    line.innerHTML = node.textContent
    for p in Parsers
      parser = new p(node, line)
      if parser.needUpdate()
        line = node = parser.exec()

    node


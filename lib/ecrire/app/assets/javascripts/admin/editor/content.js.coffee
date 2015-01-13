Joint.bind 'Editor.Content', class @Editor
  loaded: =>
    @on 'keydown', @linefeed

    @parsers = Editor.Parsers

    @extensions = Editor.Extensions.map (ext) =>
      new ext(this)

    lines = @element().textContent.split('\n')
    @element().textContent = ''
    for text in lines
      @element().appendChild(@parse(@line(text)))

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

    event = new CustomEvent('Editor:loaded', {bubbles: true})
    @element().dispatchEvent(event)


  outdated: (mutations) =>
    @observer.hold =>
      for mutation in mutations
        @appended node for node in mutation.addedNodes
        @removed node for node in mutation.removedNodes
        if mutation.type == 'characterData'
          @update mutation.target

    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)


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
        parsedLine = lines[lines.indexOf(line)] = @parse(line)
        line.parentElement.replaceChild(parsedLine, line)

      lines[1].scrollIntoView()
      @positionCursor(lines[1], 0)

    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)

  update: (node) ->
    textNode = node
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT) 
    sel = window.getSelection()
    offset = sel.focusOffset

    while walker.nextNode()
      if walker.currentNode != sel.focusNode
        offset += walker.currentNode.length
      else
        break

    el = @parse(node)
    if el.nodeName != node.nodeName || el.innerHTML != node.innerHTML
      node.parentElement.replaceChild(el, node)
      @positionCursor(el, offset)


  removed: (node) =>
    if node.nodeType != 1 || (node instanceof HTMLBRElement && node.parentElement?)
      node.remove()
      return


  appended: (node) =>
    textNode = node
    if node instanceof HTMLBRElement
      node.remove()
      return

    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    line = @parse(@line(node.textContent))

    walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT) 
    sel = window.getSelection()
    offset = sel.focusOffset

    while walker.nextNode()
      if walker.currentNode != sel.focusNode
        offset += walker.currentNode.length
      else
        break

    if line.nodeType == node.nodeType && line.innerHTML == node.innerHTML
      return

    @observer.hold =>
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
   cached = "<p></p>".toHTML()
   @line = (text) ->
     el = cached.cloneNode(true)
     if text?
       el.textContent = text

     el

    @line(text)

  parse: (node) =>
    line = @line(node.textContent)

    for p in @parsers
      line = new p(line).render()

    line

Editor.Parsers = []
Editor.Extensions = []


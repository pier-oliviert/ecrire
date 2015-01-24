Joint.bind 'Editor.Content', class @Editor
  loaded: =>
    @on 'keydown', @linefeed

    @parsers = Editor.Parsers

    @extensions = Editor.Extensions.map (ext) =>
      new ext(this)

    while (offset = @element().lastChild.textContent.indexOf('\n')) > -1
      node = @element().lastChild.splitText(offset)
      node.textContent = node.textContent.substr(1)

    for node in @element().childNodes
      if node?
        @element().replaceChild(@parse(node), node)

    @observer = new MutationObserver(@outdated)
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

      walker = @walker(line)
      text = new String()
      textNode = sel.focusNode
      found = false
      while walker.nextNode()
        text += walker.currentNode.textContent
        if !found
          if walker.currentNode == textNode
            found = true
          else
            offset += walker.currentNode.length

      lines = [
        @line(text),
        @line()
      ]

      if lines[0].childNodes.length > 0
        lines[0].childNodes[0].splitText(offset)
        lines[1].appendChild(lines[0].lastChild)

      @element().replaceChild(lines[0], line)

      if @element().lastChild == lines[0]
        @element().appendChild(lines[1])
      else
        @element().insertBefore(lines[1], lines[0].nextSibling)


      offset = lines[0].textContent.length

      for line in lines
        parsedLine = lines[lines.indexOf(line)] = @parse(line)
        if line.parentElement?
          line.parentElement.replaceChild(parsedLine, line)
          walker = @walker(parsedLine)
          if walker.currentNode.childNodes.length > 0
            while walker.nextNode()
              length = walker.currentNode.length
              if offset < length
                offset++ if walker.currentNode.textContent.indexOf("\n") > -1
                @positionCursor(parsedLine, Math.max(offset, 0))
                break
              offset -= length
          else
            @positionCursor(parsedLine, 0)

    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)

  update: (node) ->
    textNode = node
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    elements = node.querySelectorAll('[contenteditable=false]')

    walker = @walker(node)

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
    el = node
    while el? && el.parentElement != @element()
      el = el.parentElement

    return unless el?

    elements = el.querySelectorAll('[contenteditable=false]')

    for element in elements
      if element.contains(node)
        return

    if node instanceof HTMLBRElement
      node.remove()

    node = el


    line = @parse(@line(node.textContent))

    walker = @walker(node)

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
    elements = el.querySelectorAll('[contenteditable=false]')
    walker = @walker(el)

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
    if node.nodeType == document.ELEMENT_NODE 
      els = node.querySelectorAll('[contenteditable=false]')
      for el in els
        walker = @walker(el)
        while walker.nextNode()
          walker.currentNode.textContent = ''
        
    line = @line(node.textContent)

    for p in @parsers
      parser = new p(line, node)
      if parser.isMatched()
        line = parser.render()

    line

  walker: (node) ->
    elements = node.querySelectorAll('[contenteditable=false]')
    document.createTreeWalker node,
      NodeFilter.SHOW_TEXT,
      acceptNode: (node) ->
        for el in elements
          if el.contains(node)
            return NodeFilter.FILTER_REJECT
            break
        return NodeFilter.FILTER_ACCEPT

  toString: =>
    texts = []
    body = @element().cloneNode(true)
    elements = body.querySelectorAll('[contenteditable=false]')
    el.remove() for el in elements
    for line in body.children
      texts.push line.textContent

    texts.join '\n'


Editor.Parsers = []
Editor.Extensions = []


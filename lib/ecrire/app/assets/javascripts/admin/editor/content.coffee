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
      node = sel.focusNode
      root = node
      offset = sel.focusOffset

      while root? && root.parentElement != @element()
        root = root.parentElement

      walker = @walker(root)
      text = new String()
      textNode = sel.focusNode
      while walker.nextNode()
        text += walker.currentNode.textContent
        if walker.currentNode == textNode
          break
        else
          offset += walker.currentNode.length

      str = root.textContent
      root.textContent = str.substr(0, offset) + "\n" + str.substr(offset)

      lines = @convertTextToLines(root)

      line = root

      for l in lines.reverse()
        line.parentElement.insertBefore(l, line)
        line = l

      root.remove()
      lines = lines.reverse().map (line) =>
        if line.parentElement?
          el = @parse(line)
          line.parentElement.replaceChild(el, line)
          return el

      @positionCursor(lines[0], offset + 1)

    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)

  update: (node) ->
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

    lines = @convertTextToLines(node)

    line = node

    for l in lines.reverse()
      line.parentElement.insertBefore(l, line)
      line = l

    node.remove()
    lines = lines.reverse().map (line) =>
      if line.parentElement?
        el = @parse(line)
        line.parentElement.replaceChild(el, line)
        return el

    @positionCursor(lines[0], offset)

  convertTextToLines: (node) =>
    node.textContent.split('\n').map (t) =>
      @line(t)

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
      return

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
    while true
      length = el.textContent.length

      if length < offset
        offset -= length + 1
        el = el.nextElementSibling
      else
        break

    walker = @walker(el)

    sel = window.getSelection()
    range = document.createRange()

    if walker.root.textContent.length == 0
      range.setStart(walker.root, 0)
    else
      idx = 0
      while node = walker.nextNode()
        idx += node.length
        if offset <= idx
          range.setStart(node, node.length - (idx - offset))
          break

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

  walker: (node, filter = NodeFilter.SHOW_TEXT) ->
    elements = node.querySelectorAll('[contenteditable=false]')
    document.createTreeWalker node,
      filter,
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


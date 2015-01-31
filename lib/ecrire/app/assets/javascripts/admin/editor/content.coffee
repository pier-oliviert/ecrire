Joint.bind 'Editor.Content', class @Editor

  loaded: =>
    @on 'keydown', @linefeed

    @parsers = Editor.Parsers

    @extensions = Editor.Extensions.map (ext) =>
      new ext(this)

    unless @element().lastChild?
      @element().innerHTML = '<p></p>'

    lines = @lines(@element())
    @element().textContent = ''
    fragment = document.createDocumentFragment()
    fragment.appendChild(line) for line in lines
    @parse(fragment)
    while fragment.firstChild
      @element().appendChild(fragment.firstChild)

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

    sel = window.getSelection()
    node = focusNode = sel.focusNode
    offset = sel.focusOffset

    str = focusNode.textContent
    focusNode.textContent = str.substr(0, offset) + "\n" + str.substr(offset)

    while node? && node.parentElement != @element()
      node = node.parentElement
    
    offset = @lineOffset(node, focusNode, offset) + 1

    lines = @parse(@cloneNodesFrom(node))

    @observer.hold =>
      lines = @updateDOM(node, lines)
      @setCursorAt(lines[0], offset)


    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)



  update: (node) ->
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    walker = @walker(node)

    sel = window.getSelection()
    offset = @lineOffset(node, sel.focusNode, sel.focusOffset)

    lines = @parse(@cloneNodesFrom(node))

    @observer.hold =>
      lines = @updateDOM(node, lines)
      @setCursorAt(lines[0], offset)


  removed: (node) =>
    if node.nodeType != 1 || (node instanceof HTMLBRElement && node.parentElement?)
      node.remove()

    if @element().childNodes.length == 0
      p = "<p>".toHTML()
      @element().appendChild(p)
      @setCursorAt(@element(), 0)



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

    sel = window.getSelection()
    offset = @lineOffset(el, sel.focusNode, sel.focusOffset)

    lines = @parse(@cloneNodesFrom(node))

    @observer.hold =>
      lines = @updateDOM(node, lines)
      @setCursorAt(lines[0], offset)



  updateDOM: (current, fragment) =>
    return unless current?
    lines = []
    while line = fragment.firstChild
      if @same(current, line)
        lines.push(current)
        line.remove()
        current = current.nextSibling
        if current?
          continue
        else
          break
      else
        current.parentElement.replaceChild(line, current)
        lines.push(line)
        sibling = line.nextSibling
        if sibling?
          current = sibling
          continue
        else
          current = line
          while line = fragment.firstChild
            current.parentElement.appendChild(line)
            lines.push(line)
          current = null
          break

    if fragment.childNodes.length == 0
      while current
        node = current.nextSibling
        current.remove()
        current = node

    lines


  lineOffset: (line, node, offset) =>
    if node.textContent.length == 0
      return 0

    walker = @walker(line)
    while walker.nextNode()
      if walker.currentNode != node
        offset += walker.currentNode.length
      else
        break

    offset



  setCursorAt: (line, offset) ->
    sel = window.getSelection()
    range = document.createRange()
    idx = line.textContent.length

    while idx < offset
      line = line.nextSibling
      idx += Math.max(line.textContent.length, 1) + 1

    if !line.firstChild?
      range.setStart(line, 0)
    else
      remaining = line.textContent.length - (idx - offset)
      walker = @walker(line)
      while walker.nextNode()
        if walker.currentNode.length < remaining
          remaining -= walker.currentNode.length
          continue

        range.setStart(walker.currentNode, remaining)
        break

    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)



  cloneNodesFrom: (node) =>
    fragment = document.createDocumentFragment()
    while node
      clone = node.cloneNode(true)
      el.remove for el in clone.querySelectorAll('[contenteditable=false]')
      fragment.appendChild(line) for line in @lines(clone)
      node = node.nextSibling
    fragment



  lines: (node) =>
   cached = "<p></p>".toHTML()
   @lines = (node) =>
     walker = @walker(node)
     texts = new String()
     while walker.nextNode()
       texts += walker.currentNode.textContent

     texts.split('\n').map (t) =>
       el = cached.cloneNode(true)
       el.textContent = t
       el

   @lines(node)



  same: (node1, node2) =>
    w1 = @walker(node1, NodeFilter.SHOW_TEXT)
    w2 = @walker(node2, NodeFilter.SHOW_TEXT)
    n1 = w1.root
    n2 = w2.root

    while n1
      if n1.isEqualNode(n2)
        n1 = w1.nextNode()
        n2 = w2.nextNode()
      else
        return false

    !w2.nextNode()?



  parse: (fragment) =>
    for p in @parsers
      line = fragment.firstChild
      while line
        parser = new p(line)
        if parser.isMatched()
          el = parser.render()
          fragment.replaceChild(el, line)
          line = el
        line = line.nextSibling
    fragment



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


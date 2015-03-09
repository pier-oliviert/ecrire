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
        @appended(node, mutation.target) for node in mutation.addedNodes
        @removed(node, mutation.target) for node in mutation.removedNodes
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

    while node? && node.parentElement != @element()
      node = node.parentElement

    offset = @lineOffset(node, focusNode, sel.focusOffset)

    lineFeed = new LineFeed(@cloneNodesFrom(node))
    lineFeed.injectAt(offset)

    cursor = new Editor.Cursor(offset + 1)

    lines = @parse(lineFeed.fragment)

    @observer.hold =>
      line = cursor.focus(@updateDOM(node, lines)[0])
      cursor.update(@walker(line))
      @scrollLineIntoView(cursor.focus())


    event = new CustomEvent('Editor:updated', {bubbles: true})
    @element().dispatchEvent(event)



  update: (node) ->
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    walker = @walker(node)

    sel = window.getSelection()
    offset = @lineOffset(node, (sel.focusNode || node), sel.focusOffset)

    if node.previousElementSibling?
      node = node.previousElementSibling
      offset += node.toString().length + 1

    lines = @parse(@cloneNodesFrom(node))
    cursor = new Editor.Cursor(offset)

    @observer.hold =>
      line = cursor.focus(@updateDOM(node, lines)[0])
      cursor.update(@walker(line))
      @scrollLineIntoView(cursor.focus())


  removed: (node, line) =>
    while line? && line.parentElement != @element()
      line = line.parentElement

    if node.nodeType != 1 && node instanceof HTMLBRElement
      node.remove()

    if line?
      sel = window.getSelection()
      offset = @lineOffset(line, sel.focusNode, sel.focusOffset)
      cursor = new Editor.Cursor(offset)

      lines = @parse(@cloneNodesFrom(line))

      @observer.hold =>
        line = cursor.focus(@updateDOM(line, lines)[0])
        cursor.update(@walker(line))

    if @element().childNodes.length == 0
      p = "<p>".toHTML()
      @element().appendChild(p)
      cursor = new Editor.Cursor(offset)
      cursor.update(@walker(p), 0)



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
    cursor = new Editor.Cursor(offset)

    lines = @parse(@cloneNodesFrom(node))

    @observer.hold =>
      lines = @updateDOM(node, lines)
      if node != lines[0]
        cursor.update(@walker(lines[0]))
      @scrollLineIntoView(lines[0])



  scrollLineIntoView: (line) =>
    height = window.innerHeight
    rect = line.getBoundingClientRect()

    if rect.bottom > height
      line.scrollIntoView()

  updateDOM: (anchor, fragment) =>
    return unless anchor?
    current = anchor.parentElement.lastChild
    lines = []
    while (line = fragment.lastChild) && current != anchor
      if @same(current, line)
        lines.push(current)
        line.remove()
        current = current.previousSibling
        if current?
          continue
        else
          break
      else
        n = current.previousSibling
        current.parentElement.replaceChild(line, current)
        lines.push(line)
        current = n

    lines = lines.reverse()
    return lines unless anchor.parentElement?

    if fragment.childNodes.length == 1
      current = anchor
      line = fragment.lastChild
      if !@same(current, line)
        current.parentElement.replaceChild(line, current)
        lines.splice(0, 0, line)
      else
        lines.splice(0,0, current)
    else if fragment.childNodes.length > 1
      current = anchor
      while fragment.lastChild
        line = fragment.lastChild
        current.parentElement.insertBefore(line, current)
        lines.splice(0, 0, line)
        current = line
      anchor.remove()
    else if anchor != lines[0]
      current = lines[0].previousSibling
      while current != anchor
        n = current.previousSibling
        current.remove()
        current = n

      anchor.remove()

    lines


  lineOffset: (line, node, offset) =>

    if node.nodeType == document.ELEMENT_NODE
      return node.textContent.length

    if node.textContent.length == 0
      return 0

    walker = @walker(line)
    offset += line.offset(node, walker)



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
     node.toString().split('\n').map (t) =>
       el = cached.cloneNode(true)
       el.textContent = t
       el

   @lines(node)



  same: (node1, node2) =>
    node1 = node1.cloneNode(true)
    node2 = node2.cloneNode(true)

    for el in node1.querySelectorAll('[contenteditable=false]')
      el.remove()

    for el in node2.querySelectorAll('[contenteditable=false]')
      el.remove()

    node1.nodeName == node2.nodeName &&
    node1.innerHTML.trim() == node2.innerHTML.trim()




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
      texts.push line.toString()

    texts.join '\n'

class @Editor.Cursor
  constructor: (offset) ->
    @selection = window.getSelection()
    @origin = @selection.focusNode

    @offset = offset

  focus: (line) ->
    while true
      length = line.toString().length
      if length >= @offset
        break
      @offset -= Math.max(length + 1, 1)

      if line.nextSibling?
        line = line.nextSibling
        continue
      break

    @focus = ->
      line

    @focus()

  update: (walker, force = false) ->
    line = walker.root

    if !force && @selection.focusNode == @origin && line.contains(@origin)
      return

    range = line.getRange(@offset, walker)

    @selection.removeAllRanges()
    @selection.addRange(range)

class LineFeed
  constructor: (@fragment) ->

  injectAt: (offset) ->
    node = @fragment.firstChild
    while node && offset > 0
      length = node.textContent.length
      if offset > length
        offset -= length  + 1
        node = node.nextSibling
      else
        break

    if !node?
      @append(@fragment.lastChild)
    else
      @insert(node, offset)

  append: (lastChild) ->
    node = lastChild.cloneNode(true)
    node.textContent = ''
    @fragment.appendChild(node)

  insert: (root, offset) ->
    node = root.cloneNode(true)

    root.textContent = root.textContent.substr(0, offset)
    node.textContent = node.textContent.substr(offset)

    if root.nextSibling?
      @fragment.insertBefore(node, root.nextSibling)
    else
      @fragment.appendChild(node)


Editor.Parsers = []
Editor.Extensions = []

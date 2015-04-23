ObserveJS.bind 'Editor.Content', class @Editor

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



  outdated: (observedMutations) =>
    @observer.hold =>
      mutations = new Mutations(observedMutations, @element())
      if mutations.target?
        @updated(mutations)

      if @element().children.length == 0
        line = @lines('')[0]
        @element().appendChild(line)
        cursor = new Editor.Cursor(0)
        cursor.update(@walker(line), 0)


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



  updated: (mutations) ->
    if mutations.target.contentEditable == 'false'
      return

    node = mutations.target
    while node? && node.parentElement != @element()
      node = node.parentElement

    return unless node?

    walker = @walker(node)

    sel = window.getSelection()
    if sel.type == 'None'
      offset = 0
    else
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


class Mutations
  constructor: (mutations, editor) ->
    @removed = []
    @appended = []
    @updated = []

    for mutation in mutations
      @setTarget(mutation.target, editor)
      if mutation.addedNodes.length > 0
        @appended.push mutation.target
      else if mutation.type == 'characterData'
        @updated.push mutation.target
      else
        @removed.push mutation.target

  setTarget: (target, editor) ->
    return unless target.parentElement? && target != editor
    if @target? && @target.compareDocumentPosition(target) & Node.DOCUMENT_POSITION_FOLLOWING
      @target = target
    else
      @target = target

  status: =>
    if @appended.length > 0
      "appended"
    else if @updated.length > 0
      'updated'
    else if @removed.length > 0
      'removed'
    else
      'none'

Editor.Parsers = []
Editor.Extensions = []

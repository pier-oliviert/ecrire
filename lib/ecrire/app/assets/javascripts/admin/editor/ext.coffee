String::toHTML = ->
  el = document.createElement('div')
  el.innerHTML = this
  if el.children.length > 1
    el.children
  else
    el.children[0]

Text::toString = ->
  @textContent

HTMLOListElement::toString = HTMLUListElement::toString = ->
  texts = Array.prototype.slice.call(@children).map (li) ->
    li.textContent
  texts.join("\n")

HTMLDivElement::toString = ->
  if @classList.contains('image')
    @lastChild.textContent
  else
    @textContent

HTMLPreElement::toString = ->
  @textContent

HTMLElement::toString = ->
  if @nodeName == 'FIGURE'
    @querySelector('figcaption').textContent
  else
    @textContent

HTMLHeadingElement::toString = HTMLParagraphElement::toString = ->
  @textContent

HTMLElement::offset = (node, walker) ->
  offset = 0

  while walker.nextNode()
    if walker.currentNode != node
      offset += walker.currentNode.length
    else
      break

  offset

HTMLOListElement::offset = HTMLUListElement::offset = (node, walker) ->
  offset = 0
  li = this.firstElementChild

  while walker.nextNode()
    if !li.contains(walker.currentNode)
      newList = walker.currentNode
      while newList? && !(newList instanceof HTMLLIElement)
        newList = newList.parentElement
      li = newList
      offset++

    if walker.currentNode != node
      offset += walker.currentNode.length
    else
      break

  offset

HTMLElement::getRange = (offset, walker) ->
  range = document.createRange()

  if !@firstChild?
    range.setStart(this, 0)
  else
    while walker.nextNode()
      if walker.currentNode.length < offset
        offset -= walker.currentNode.length
        continue

      range.setStart(walker.currentNode, offset)
      break

  range.collapse(true)
  range


HTMLOListElement::getRange = HTMLUListElement::getRange = (offset, walker) ->
  range = document.createRange()
  if !@firstChild?
    range.setStart(this, 0)
    return

  li = this.firstElementChild

  while walker.nextNode()
    if !li.contains(walker.currentNode)
      newList = walker.currentNode
      while newList? && !(newList instanceof HTMLLIElement)
        newList = newList.parentElement
      li = newList
      offset--

    if walker.currentNode.length < offset
      offset -= walker.currentNode.length
      continue
    range.setStart(walker.currentNode, offset)
    break

  range.collapse(true)
  range

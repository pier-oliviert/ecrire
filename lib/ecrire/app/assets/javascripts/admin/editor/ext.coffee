String::toHTML = ->
  el = document.createElement('div')
  el.innerHTML = this
  if el.children.length > 1
    el.children
  else
    el.children[0]

Text::toString = ->
  @textContent

HTMLUListElement::toString = ->
  texts = Array.prototype.slice.call(@children).map (li) ->
    li.textContent
  texts.join("\n")

HTMLPictureElement::toString = HTMLPreElement::toString = HTMLHeadingElement::toString = HTMLDivElement::toString = HTMLParagraphElement::toString = ->
  @textContent

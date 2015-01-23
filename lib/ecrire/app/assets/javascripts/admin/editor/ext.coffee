String::toHTML = ->
  el = document.createElement('div')
  el.innerHTML = this
  if el.children.length > 1
    el.children
  else
    el.children[0]

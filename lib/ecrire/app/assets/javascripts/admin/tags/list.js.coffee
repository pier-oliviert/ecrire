Joint.bind 'Tags.List', class
  loaded: =>
    @on 'keypress', @element().querySelector('input'), @submit
    @on 'click', @element().querySelector('ul'), @update
    @on 'tags:update', @toggle
    @on 'tags:create', @add

  submit: (e) =>
    if e.keyCode != 13
      return

    xhr = new Joint.XHR(e.target)
    xhr.method = 'POST'
    xhr.data.set '[tag]name', e.target.value
    xhr.send()

  update: (e) =>
    return unless e.target instanceof HTMLLIElement
    xhr = new Joint.XHR(e.target)
    xhr.send()

  toggle: (e) =>
    li = @element().querySelector("[oid='#{e.ObjectID}']")
    li.remove()

  add: (e) =>
    @element().querySelector('input').value = ''
    target = @element().querySelector("[oid='#{e.HTML.getAttribute('oid')}']")
    if target?
      target.classList.add('highlight')
    else
      ul = @element().querySelector('ul')
      ul.insertBefore(e.HTML, ul.firstElementChild)
      e.HTML.classList.add('highlight')

Joint.bind 'Tags.List', class
  loaded: =>
    @on 'keypress', @element().querySelector('input'), @submit
    @on 'click', @element().querySelector('ul'), @update
    @on 'tags:update', @toggle

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

Joint.bind 'Editor.Published', class
  resetInterval: 4000
  loaded: =>
    @on 'change', @element().querySelector('input[type=checkbox]'), @toggle

  toggle: (e) =>
    if e.target.checked
      @show()
    else
      @hide()

  show: =>
    el = @element().firstElementChild
    @element().querySelector('form.destroy').classList.remove('hide')
    setTimeout @reset, @resetInterval

  hide: =>
    el = @element().firstElementChild
    @element().querySelector('form.destroy').classList.add('hide')


  reset: =>
    checkbox = @element().querySelector('input[type=checkbox]')
    if checkbox.checked
      checkbox.checked = false
      @hide()


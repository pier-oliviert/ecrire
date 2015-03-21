ObserveJS.bind 'Editor.Draft', class
  resetInterval: 4000
  loaded: =>
    @on 'Editor:updated', document, @update
    @on 'change', @element().querySelector('input[type=checkbox]'), @toggle

  toggle: (e) =>
    if e.target.checked
      @show()
    else
      @hide()

  show: =>
    el = @element().firstElementChild
    el.style.marginLeft = "-#{el.getBoundingClientRect().width}px"
    el.style.opacity = 0
    @element().querySelector('form.destroy').classList.remove('hide')
    @timerID = setTimeout @reset, @resetInterval

  hide: =>
    if @timerID?
      clearTimeout(@timerID)
      @timerID = null

    el = @element().firstElementChild
    el.style.marginLeft = ''
    el.style.opacity = 1
    @element().querySelector('form.destroy').classList.add('hide')


  reset: =>
    checkbox = @element().querySelector('input[type=checkbox]')
    if checkbox.checked
      checkbox.checked = false
      @hide()

  update: (e) =>
    unless @cached?
      @cached = e.target.textContent
      return

ObserveJS.bind 'Editor.Save', class
  loaded: =>
    @button = @element().querySelector('button')
    @time = @element().querySelector('div.update > p')

    @on 'keydown', document, @shouldSave
    @on 'Editor:loaded', document, @cache
    @on 'Editor:updated', document, @update
    @on 'posts:update', document, @saved
    @on 'click', @button, @save
    @on 'beforeunload', window, @confirm

    @button.textContent = @button.getAttribute('persisted')
    @refresh()
    @cache()
    @interval = setInterval(@refresh, 1000)

  refresh: () =>
    @time.textContent = moment(@time.getAttribute('time')).fromNow()

  confirm: (e) =>
    if @cache() != PostBody.instance.toString()
      e.returnValue = "You have unsaved changed."
      return e.returnValue

  cache: =>
    cache = PostBody.instance.toString()
    @cache = (refresh) ->
      if refresh
        cache = PostBody.instance.toString()
        @button.setAttribute('disabled', 'disabled')
        @button.textContent = @button.getAttribute('persisted')
      cache
    @cache()

  dirty: =>
    @cache()? && @cache() != PostBody.instance.toString()

  shouldSave: (e) =>
    if e.metaKey isnt true || e.which isnt 83
      return

    e.preventDefault()
    e.stopPropagation()

    if @dirty()
      @save(e)
    else
      @nudge()

  nudge: =>
    button = document.querySelector("[as='Editor.Save'] button")
    clean = ->
      button.classList.remove('nudge')

    button.addEventListener 'animationend', clean
    button.addEventListener 'webkitAnimationEnd', clean
    button.classList.add('nudge')

  save: (e) =>
    e.preventDefault()
    e.stopPropagation()

    form = document.querySelector("[as='Editor.Save']")
    xhr = new ObserveJS.XHR(form)
    xhr.data.set('post[content]', PostBody.instance.toString())
    xhr.data.set('context', 'content')
    xhr.send()

  saved: (e) =>
    if e.UpdatedAtTime
      @time.setAttribute('time', e.UpdatedAtTime)
      @refresh()
      @cache(true)

  update: (e) =>
    if @dirty()
      @button.removeAttribute('disabled')
      @button.textContent = @button.getAttribute('dirty')
    else
      @button.setAttribute('disabled', 'disabled')
      @button.textContent = @button.getAttribute('persisted')

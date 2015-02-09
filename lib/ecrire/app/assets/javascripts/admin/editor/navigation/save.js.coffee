Joint.bind 'Editor.Save', class
  loaded: =>
    @button = @element().querySelector('button')
    @time = @element().querySelector('div.update > p')

    @on 'Editor:loaded', document, @cache
    @on 'Editor:updated', document, @update
    @on 'posts:update', document, @saved
    @on 'click', @button, @save
    @on 'beforeunload', window, @confirm

    @button.innerText = @button.getAttribute('persisted')
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
        @button.innerText = @button.getAttribute('persisted')
      cache
    @cache()

  save: (e) =>
    e.preventDefault()
    e.stopPropagation()

    xhr = new Joint.XHR(e.target.form)
    xhr.data.set('post[content]', PostBody.instance.toString())
    xhr.data.set('context', 'content')
    xhr.send()

  saved: (e) =>
    if e.MessageHTML
      event = new CustomEvent('Editor:message', { bubbles: true})
      event.MessageHTML = e.MessageHTML
      @element().dispatchEvent(event)
      @time.setAttribute('time', e.UpdatedAtTime)
      @refresh()
      @cache(true)

  update: (e) =>
    return unless @cache()?
    if @cache() != PostBody.instance.toString()
      @button.removeAttribute('disabled')
      @button.innerText = @button.getAttribute('dirty')
    else
      @button.setAttribute('disabled', 'disabled')
      @button.innerText = @button.getAttribute('persisted')


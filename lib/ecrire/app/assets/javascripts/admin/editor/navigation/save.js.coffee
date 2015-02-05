Joint.bind 'Editor.Save', class
  loaded: =>
    @on 'Editor:loaded', document, @cache
    @on 'Editor:updated', document, @update
    @on 'posts:update', document, @saved
    @on 'click', @save
    @on 'beforeunload', window, @confirm

    @element().innerText = @element().getAttribute('persisted')


  confirm: (e) =>
    if @cache() != PostBody.innerHTML
      e.returnValue = "You have unsaved changed."
      return e.returnValue

  cache: =>
    cache = PostBody.innerHTML
    @cache = (refresh) ->
      if refresh
        cache = PostBody.innerHTML
        @element().setAttribute('disabled', 'disabled')
        @element().innerText = @element().getAttribute('persisted')
      cache

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
      @cache(true)

  update: (e) =>
    return unless @cache()?
    if @cache() != PostBody.innerHTML
      @element().removeAttribute('disabled')
      @element().innerText = @element().getAttribute('dirty')
    else
      @element().setAttribute('disabled', 'disabled')
      @element().innerText = @element().getAttribute('persisted')


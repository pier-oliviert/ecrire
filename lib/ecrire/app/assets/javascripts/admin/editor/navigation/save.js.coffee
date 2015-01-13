Joint.bind 'Editor.Save', class
  loaded: =>
    @on 'Editor:loaded', document, @cache
    @on 'Editor:updated', document, @update
    @on 'posts:update', document, => @cache(true)
    @on 'click', @save

    @element().innerText = @element().getAttribute('persisted')


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

    texts = Array.prototype.slice.call(PostBody.childNodes).map (n) -> n.textContent
    xhr = new Joint.XHR(e.target.form)
    xhr.data.set('post[content]', texts.join('\n'))
    xhr.data.set('context', 'content')
    xhr.send()

  update: (e) =>
    return unless @cache()?
    if @cache() != PostBody.innerHTML
      @element().removeAttribute('disabled')
      @element().innerText = @element().getAttribute('dirty')
    else
      @element().setAttribute('disabled', 'disabled')
      @element().innerText = @element().getAttribute('persisted')


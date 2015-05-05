ObserveJS.bind 'Editor.Save', class
  loaded: =>
    @on 'click', @save
    @on 'keydown', window, @shouldSave
    @on 'Editor:loaded', document, @cache
    @on 'Editor:updated', document, @update
    @on 'posts:update', document, @saved
    @on 'beforeunload', window, @confirm

  confirm: (e) =>
    if @cache() != PostBody.instance.toString()
      e.returnValue = "You have unsaved changed."
      return e.returnValue

  cache: =>
    cache = PostBody.instance.toString()
    @cache = (refresh) ->
      if refresh
        cache = PostBody.instance.toString()
      cache
    @cache()

  shouldSave: (e) =>
    @cache()
    if e.metaKey isnt true || e.which isnt 83
      return

    @save(e)

  save: (e) =>
    e.preventDefault()
    e.stopPropagation()

    dialog = @retrieve('#SavePost').cloneNode(true)
    document.body.appendChild(dialog)

  saved: (e) =>
    @cache(true)

ObserveJS.bind 'Editor.Save.Dialog', class
  loaded: =>
    @on 'posts:update', document, @saved
    xhr = new ObserveJS.XHR(@element())
    xhr.data.set('post[content]', PostBody.instance.toString())
    xhr.data.set('context', 'content')
    xhr.request.upload.addEventListener 'progress', @upload
    xhr.request.addEventListener 'progress', @download
    xhr.send()

  remove: =>
    if @element().classList.contains 'fade'
      @element().remove()
      return

    @element().classList.add 'fade'
    @on 'webkitTransitionEnd', @remove
    @on 'transitionEnd', @remove

  saved: (e) =>
    msg = @element().querySelector('.message')
    msg.innerHTML = e.MessageHTML
    window.setTimeout @remove, 400

  download: (e) =>
    if e.lengthComputable
      @element().querySelector('.progress').style.width = "#{50 + e.total / e.loaded * 50}%"
    else
      @element().querySelector('.progress').style.width = "100%"

  upload: (e) =>
    @element().querySelector('.progress').style.width = "#{e.total / e.loaded * 50}%"

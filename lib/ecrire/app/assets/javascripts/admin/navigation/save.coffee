ObserveJS.bind 'Editor.Save', class
  loaded: =>
    @on 'click', @save
    @when 'keydown', @shouldSave
    @when 'Editor:loaded', @cache
    @when 'posts:update', @saved
    @when 'beforeunload', @confirm

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

    dialog = @template('#SavePost')

    if e.type == 'click'
      dialog.dataset.preview = true

    document.body.appendChild(dialog)

  saved: (e) =>
    @cache(true)

ObserveJS.bind 'Editor.Save.Dialog', class
  loaded: =>
    @when 'posts:update', @saved
    xhr = new ObserveJS.XHR(@element())
    xhr.data.set('post[content][raw]', PostBody.instance.history.current.toString())
    xhr.data.set('post[content][html]', PostBody.instance.history.current.toHTMLString())
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
    if @element().dataset.preview == 'true'
      window.location = @element().getAttribute('href')
    else
      window.setTimeout @remove, 400

  download: (e) =>
    if e.lengthComputable
      @element().querySelector('.progress').style.width = "#{50 + e.total / e.loaded * 50}%"
    else
      @element().querySelector('.progress').style.width = "100%"

  upload: (e) =>
    @element().querySelector('.progress').style.width = "#{e.total / e.loaded * 50}%"

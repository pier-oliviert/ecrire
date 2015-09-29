ObserveJS.bind 'Post.Header', class
  loaded: =>
    @on 'click', @element().querySelector('p.browse'), @open
    @on 'click', @element().querySelector('svg.clear'), @remove
    @on 'change', @element().querySelector('input[type=file]'), @submit
    @on 'dragover', @over
    @on 'dragleave', @cancel
    @on 'drop', @drop

    @on 'ObserveJS:XHR:Failed', @failed

    @on 'images:create', @refresh
    @on 'images:destroy', @refresh

    @on 'scroll', window, @resize

    @maxHeight = parseFloat(window.getComputedStyle(this.element())['height'])

    @resize()

  resize:  =>
    if document.querySelector('main').classList.contains('overlayed')
      return

    height = @maxHeight - document.body.scrollTop
    if height < 0
      height = 0

    if height != @maxHeight
      @element().querySelector('nav').classList.add 'hidden'
    else
      @element().querySelector('nav').classList.remove 'hidden'

    @element().style.height = "#{height}px"

  show: (el) =>
    @show.container ||= @element().querySelector('div.drop')
    unless el.parentElement?
      @element().querySelector('div.drop').appendChild(el)

    for child in @show.container.children
      child.classList.add 'hidden'

    el.classList.remove('hidden')

  hide: (el) =>
    el.classList.add('hidden')

  outside: (e, rect) ->
    e.x >= (rect.left + rect.width) ||
    e.x <= rect.left ||
    e.y >= (rect.top + rect.height) ||
    e.y <= rect.top

  progress: (e) =>
    return unless e.lengthComputable
    percentComplete = e.loaded / e.total * 100.0;
    progressBar = @retrieve('div.status.uploading').querySelector('.progressbar')
    progressBar.firstElementChild.style.width = "#{percentComplete}%";

  failed: (e) =>
    errors = JSON.parse(e.response.target.responseText)
    @hide(@retrieve('div.status.uploading'))
    @show(@retrieve('div.error.status'))
    ul = @retrieve('div.error.status').querySelector('ul')
    @on 'click', @retrieve('div.error.status').querySelector('button'), @clear
    for error in errors
      ul.insertAdjacentHTML('beforeend', "<li>#{error}</li>")

  open: (e) =>
    @element().querySelector('input[type=file]').click()

  remove: (e) =>
    xhr = new ObserveJS.XHR(e.currentTarget)
    xhr.request.upload.onprogress = @progress
    xhr.send()

  over: (e) =>
    e.preventDefault()
    if !@element().classList.contains('image')
      @element().classList.add 'image'
      @show(@retrieve('div.dropping.status'))

  cancel: (e) =>
    e.preventDefault()
    rect = @element().getBoundingClientRect()
    if @outside(e, rect)
      @clear(e)

  drop: (e) =>
    e.preventDefault()
    if e.dataTransfer.files.length > 0
      @upload(e.dataTransfer.files[0])

  submit: (e) =>
    if e.target.files.length > 0
      @upload(e.target.files[0])

    e.target.value = ''

  upload: (file) =>
    if !@element().classList.contains('image')
      @element().classList.add 'image'

    @show(@retrieve('div.status.uploading'))
    @retrieve('div.status.uploading').querySelector('.progressbar > span').style.width = '0%';
    xhr = new ObserveJS.XHR(@element())
    xhr.data.set 'image[file]', file
    xhr.request.upload.onprogress = @progress
    xhr.send()

  loading: =>
    @element().firstElementChild.appendChild(@retrieve('div.status.uploading'))

  clear: (e) =>
    @element().classList.remove 'image'
    for li in @retrieve('div.error.status').querySelectorAll('li')
      li.remove()

    for status of @statuses
      @statuses[status].classList.add 'hidden'

    if @element().style.backgroundImage.length == 0
      @element().querySelector('svg.clear').classList.add('hidden')
    else
      @element().querySelector('svg.clear').classList.remove('hidden')


  refresh: (e) =>
    if e.headerURL?
      @element().style.backgroundImage = "url(#{e.headerURL})"
    else
      @element().style.backgroundImage = null

    @clear()

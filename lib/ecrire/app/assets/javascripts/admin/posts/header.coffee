ObserveJS.bind 'Post.Header', class
  loaded: =>
    @statuses = {
      uploading: @element().querySelector('div.uploading.status'),
      dropping: @element().querySelector('div.dropping.status'),
      error: @element().querySelector('div.error.status'),
    }

    @on 'click', @element().querySelector('p.browse'), @open
    @on 'click', @element().querySelector('svg.clear'), @remove
    @on 'change', @element().querySelector('input[type=file]'), @submit
    @on 'dragover', @over
    @on 'dragleave', @cancel
    @on 'drop', @drop

    @on 'ObserveJS:XHR:Failed', @failed

    @on 'click', @statuses.error.querySelector('button'), @clear

    @on 'images:create', @refresh
    @on 'images:destroy', @refresh
    @on 'titles:index', @popup
    @on 'titles:update', document, @updateTitle
    @on 'titles:create', document, @updateTitle

  popup: (e) =>
    document.body.appendChild(e.HTML)

  show: (el) =>
    for status of @statuses
      @statuses[status].classList.add 'hidden'
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
    progressBar = @statuses.uploading.querySelector('.progressbar')
    progressBar.firstElementChild.style.width = "#{percentComplete}%";

  failed: (e) =>
    errors = JSON.parse(e.response.target.responseText)
    @hide(@statuses.uploading)
    @show(@statuses.error)
    ul = @statuses.error.querySelector('ul')
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
      @show(@statuses.dropping)

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

    @show(@statuses.uploading)
    @statuses.uploading.querySelector('.progressbar > span').style.width = '0%';
    xhr = new ObserveJS.XHR(@element())
    xhr.data.set 'image[file]', file
    xhr.request.upload.onprogress = @progress
    xhr.send()

  loading: =>
    @element().firstElementChild.appendChild(@statuses.uploading)

  clear: (e) =>
    @element().classList.remove 'image'
    for li in @statuses.error.querySelectorAll('li')
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

  updateTitle: (e) =>
    unless e.Errors?
      @element().querySelector('a.title').textContent = e.Title

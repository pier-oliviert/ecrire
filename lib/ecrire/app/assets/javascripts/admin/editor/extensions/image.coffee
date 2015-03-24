ObserveJS.bind 'Editor.Image', class
  loaded: =>
    @element().addEventListener 'dragover', @over
    @element().addEventListener 'dragleave', @cancel
    @element().addEventListener 'drop', @drop
    @on 'click', @container(), @open
    @on 'change', @element().querySelector('input'), @upload
    if @element().querySelector('figcaption').hasAttribute('name')
      @show()
    else
      @placehold()

  over: (e) =>
    e.preventDefault()
    @element().classList.add 'dropping'

  cancel: (e) =>
    e.preventDefault()
    @element().classList.remove 'dropping'

  drop: (e) =>
    e.preventDefault()
    @element().classList.remove 'dropping'
    e.file = e.dataTransfer.files[0]
    @upload(e)

  show: =>
    img = @retrieve('img')
    img.src = @element().querySelector('figcaption').getAttribute('name')
    @container().appendChild(img)

  placehold: =>
    placeholder = @retrieve('.placeholder')
    @container().appendChild(placeholder)

  container: =>
    @container.element ||= @element().querySelector('div[contenteditable=false]')

  open: =>
    @container().querySelector('input').click()

  uploaded: (e) =>
    xml = new DOMParser().parseFromString(e.target.response, 'text/xml')
    url = xml.querySelector('Location').textContent
    img = @retrieve('img')
    img.src = url
    progressBar = @retrieve('.progressbar')
    @container().insertBefore(img, progressBar)
    progressBar.remove()
    @retrieve('.placeholder').remove()
    @element().querySelector('figcaption').lastChild.textContent = "(#{url})"

  upload: (e) =>
    @container().appendChild(@retrieve('.progressbar'))
    unless e.file?
      e.file = e.target.files[0]
    id = PostBody.getAttribute('postid')
    policy = PostBody.getAttribute('policy')
    signature = PostBody.getAttribute('signature')
    bucket = PostBody.getAttribute('bucket')
    namespace = PostBody.getAttribute('namespace')
    access_key = PostBody.getAttribute('access_key')

    url = "https://s3.amazonaws.com/#{bucket}/"
    dir = [id]
    if namespace?
      dir.splice(0,0, namespace)

    dir = dir.join '/'

    data = new FormData()
    data.append 'AWSAccessKeyId', access_key
    data.append 'success_action_status', 201
    data.append 'acl', 'private'
    data.append 'policy', policy
    data.append 'signature', signature
    data.append 'key', "#{dir}/#{e.file.name}"
    data.append 'Content-Type', e.file.type
    data.append 'file', e.file

    xhr = new XMLHttpRequest()
    xhr.open('POST', url, true)
    xhr.onload = @uploaded
    xhr.onprogress = @progress
    xhr.send(data)

  progress: (e) =>
    return unless e.lengthComputable
    percentComplete = e.loaded / e.total * 100.0;
    progressBar = @retrieve('.progressbar')
    progressBar.firstElementChild.style.width = "#{percentComplete}%";

Editor.Parsers.push class
  rule: /^(!{1}\[([^\]]+)\])(\(([^\s]+)?\))$/i

  constructor: (node) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)

  isMatched: =>
    @match = @rule.exec(@walker.root.textContent)
    @match?

  render: =>
    @container = new Container()

    @uploader = new Editor.ImageUploader(@show)


    @picture = "<div class='image' as='Editor.Image'>".toHTML()

    @title = "<em></em>".toHTML()
    @title.appendChild document.createTextNode(@match[1])
    @title.appendChild document.createTextNode(@match[3])
    if @match[4]?
      @title.setAttribute('name', @match[4])

    @picture.appendChild @container.toHTML(@match[4])
    @picture.appendChild @title

    @container.input.addEventListener 'change', @update
    @picture.addEventListener 'drop', @drop

    return @picture

  show: (e, url) =>
    @container.image(url)
    @title.lastChild.textContent = "(#{url})"

  update: (e) =>
    unless e.file?
      e.file = e.target.files[0]
    @container.loading()
    @uploader.send(e)

  drop: (e) =>
    e.preventDefault()
    e.file = e.dataTransfer.files[0]
    @update(e)


class Container
  constructor: ->
    @el = "<div contenteditable=false></div>".toHTML()
    @el.addEventListener 'click', @open

    if !(@input = @el.querySelector('input'))?
      @input = "<input type='file'>".toHTML()

    @el.appendChild(@input)

  image: (url) =>
    @el.style.backgroundImage = "url(#{url})"
    @el.innerHTML = ''
    @el.classList.remove 'loading'

  loading: =>
    @loading = =>
      @el.classList.add 'loading'
      @el.innerHTML = ''

    @loading()

  placeholder: =>
    el = "<p>Drop an image or click here to upload a picture.</p>".toHTML()
    @placeholder = =>
      @el.innerHTML = ''
      @el.appendChild(el)

    @placeholder()

  open: (e) =>
    @input.click()

  toHTML: (url) =>
    if url?
      @image(url)
    else if @el.classList.contains('loading')
      @loading()
    else
      @placeholder()

    @el


class Editor.ImageUploader
  constructor: (@callback) ->

  uploaded: (e) =>
    xml = new DOMParser().parseFromString(e.target.response, 'text/xml')
    url = xml.querySelector('Location').textContent
    @callback(e, url)

  send: (e) =>
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
    xhr.send(data)

Editor.Parsers.push class
  rule: /^(!{1}\[([^\]]+)\])(\(([^\s]+)?\))$/i

  constructor: (node, @el) ->
    @walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT)
    node.querySelector('[contenteditable=false]')?.remove()

  render: =>

    match = @rule.exec(@walker.root.textContent)
    return @walker.root unless match?


    @picture = "<picture>".toHTML()
    @input = "<input type='file'>".toHTML()

    @title = "<em></em>".toHTML()
    @title.appendChild document.createTextNode(match[1])
    @title.appendChild document.createTextNode(match[3])
    @title.setAttribute('name', match[4])

    placeholder = "<p>Click here to upload a picture.</p>".toHTML()
    @container = "<div contenteditable=false></div>".toHTML()
    @container.appendChild(@input)

    @container.addEventListener 'click', @open
    @picture.appendChild @container
    @picture.appendChild @title

    uploader = new Editor.ImageUploader(@preview)
    @input.addEventListener 'change', uploader.update
    oldContainer = @el.querySelector('div')
    if @el? && @el.nodeName == 'PICTURE' && oldContainer.getAttribute('name') == @title.getAttribute('name')
      @picture.replaceChild(oldContainer, @container)
      @container = oldContainer

    if match[4]?
      @container.style.backgroundImage = "url(#{match[4]})"
    else
      @container.appendChild(placeholder)

    return @picture

  open: (e) =>
    @input.click()

  preview: (e, url) =>
    @container.style.backgroundImage = "url(#{url})"
    @container.innerHTML = ''
    @title.lastChild.textContent = "(#{url})"


class Editor.ImageUploader
  constructor: (@callback) ->

  update: (e) =>
    reader = new FileReader()
    reader.onload = @updated
    reader.image = e.target.files[0]
    reader.readAsDataURL(reader.image)
    @upload(e)

  updated: (e) =>

  uploaded: (e) =>
    xml = new DOMParser().parseFromString(e.target.response, 'text/xml')
    url = xml.querySelector('Location').textContent
    @callback(e, url)


  upload: (e) =>
    id = PostBody.getAttribute('postid')
    policy = PostBody.getAttribute('policy')
    signature = PostBody.getAttribute('signature')

    url = "https://ecrire_test.s3.amazonaws.com/"

    data = new FormData()
    data.append 'AWSAccessKeyId', 'AKIAJJ4TMZJMEQW4VYLQ'
    data.append 'success_action_status', 201
    data.append 'acl', 'private'
    data.append 'policy', policy
    data.append 'signature', signature
    data.append 'key', "#{id}/#{e.target.files[0].name}"
    data.append 'file', e.target.files[0]

    xhr = new XMLHttpRequest()
    xhr.open('POST', url, true)
    xhr.onload = @uploaded
    xhr.send(data)

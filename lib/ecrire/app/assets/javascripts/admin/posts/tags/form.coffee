ObserveJS.bind 'Post.Tags.Form', class
  loaded: =>
    @on 'input', @search
    @on 'submit', @send
    @on 'tags:index', @refresh
    @on 'tags:create', @append

    @element().querySelector('#TagName').focus()

  send: (e) =>
    e.preventDefault()
    e.stopPropagation()
    ObserveJS.XHR.send(@element())

  search: (e) =>
    xhr = new ObserveJS.XHR(@element())
    xhr.method = 'GET'
    xhr.data.set 'q', e.target.value
    xhr.send()

  append: (e) =>
    oid = e.HTML.getAttribute('oid')
    list = @element().nextElementSibling
    el = list.querySelector("[oid='#{oid}']")

    if el?
      el.parentElement.replaceChild(e.HTML, el)
      return

    el = list.querySelector('li.empty')
    if el?
      el.remove()
      list.appendChild(e.HTML)
      return
    
  refresh: (e) =>
    sibling = @element().nextElementSibling
    list = e.HTML.querySelector('ul.tags')
    @element().parentElement.replaceChild(list, sibling)

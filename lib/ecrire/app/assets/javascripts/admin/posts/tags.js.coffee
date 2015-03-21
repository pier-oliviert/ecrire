ObserveJS.bind 'Post.Tags', class
  loaded: =>
    @on 'tags:index', @show
    @on 'tags:update', document, @update

  show: (e) =>
    document.body.appendChild(e.HTML)
    e.HTML.querySelector('input').focus()

  update: (e) =>
    target = @element().querySelector("[oid='#{e.HTML.getAttribute('oid')}']")
    if target?
      target.remove()
    else
      @element().insertBefore(e.HTML, @element().lastElementChild)

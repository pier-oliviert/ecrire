ObserveJS.bind 'Post.Tags', class
  loaded: =>
    @on 'tags:toggle', document, @refresh
    @on 'tags:create', document, @refresh
    @on 'tags:index', @show

  refresh: (e) =>
    @element().innerHTML = e.TagsHTML.innerHTML

  show: (e) =>
    document.body.appendChild(e.HTML)

ObserveJS.bind 'Post.Tags', class
  loaded: =>
    @when 'tags:toggle', @refresh
    @when 'tags:create', @refresh
    @on 'tags:index', @show

  refresh: (e) =>
    @element().innerHTML = e.TagsHTML.innerHTML

  show: (e) =>
    document.body.appendChild(e.HTML)

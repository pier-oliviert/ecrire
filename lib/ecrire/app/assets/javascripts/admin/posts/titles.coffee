ObserveJS.bind 'Post.Titles', class
  loaded: =>
    @on 'titles:update', document, @refresh
    @on 'titles:create', document, @refresh

  refresh: (e) =>
    @element().innerHTML = e.HTML.innerHTML


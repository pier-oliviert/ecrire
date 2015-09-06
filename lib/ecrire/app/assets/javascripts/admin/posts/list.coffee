ObserveJS.bind 'Posts.List', class
  loaded: =>
    @on 'posts:index', document, @refresh

  refresh: (e) =>
    @element().innerHTML = e.HTML.innerHTML

ObserveJS.bind 'Posts.List', class
  loaded: =>
    @on 'posts:index', document, @refresh
    @on 'posts:drafts', document, @refresh
    @on 'posts:published', document, @refresh

  refresh: (e) =>
    @element().innerHTML = e.HTML.innerHTML

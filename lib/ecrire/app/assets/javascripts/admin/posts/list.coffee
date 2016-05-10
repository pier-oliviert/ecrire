ObserveJS.bind 'Posts.List', class
  loaded: =>
    @when 'posts:index', @refresh
    @when 'posts:drafts', @refresh
    @when 'posts:published', @refresh

  refresh: (e) =>
    @element().innerHTML = e.HTML.innerHTML

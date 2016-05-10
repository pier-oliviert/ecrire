ObserveJS.bind 'Post.Title', class
  loaded: =>
    @on 'titles:index', @show
    @when 'titles:update', @refresh
    @when 'titles:create', @refresh

  show: (e) =>
    e.HTML.dataset.y = document.body.scrollTop
    document.body.appendChild(e.HTML)

  refresh: (e) =>
    if e.HTML?
      @element().textContent = e.HTML.dataset.name


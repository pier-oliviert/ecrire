ObserveJS.bind 'Post.Title', class
  loaded: =>
    @on 'titles:index', @show
    @on 'titles:update', document, @refresh

  show: (e) =>
    document.body.appendChild(e.HTML)

  refresh: (e) =>
    @element().textContent = e.HTML.children[0].textContent


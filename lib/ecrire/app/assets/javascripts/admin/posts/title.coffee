ObserveJS.bind 'Post.Title', class
  loaded: =>
    @on 'titles:index', @show
    @on 'titles:update', document, @refresh
    @on 'titles:create', document, @refresh

  show: (e) =>
    document.body.appendChild(e.HTML)
    e.HTML.querySelector('form input[type=text]').focus()

  refresh: (e) =>
    if e.HTML?
      @element().textContent = e.HTML.dataset.name


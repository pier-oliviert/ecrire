Joint.bind 'Posts.Popup', class
  loaded: =>
    @on 'posts:index', @show

  show: (e) =>
    document.body.appendChild(e.HTML)


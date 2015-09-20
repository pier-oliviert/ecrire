ObserveJS.bind 'Post.Documentation', class
  loaded: =>
    @on 'posts:help', @show

  show: (e) =>
    document.body.appendChild e.HTML

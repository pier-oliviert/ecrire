ObserveJS.bind 'Post.Publish', class
  loaded: =>
    @on 'click', @toggle
    @on 'posts:toggle', @refresh

  toggle: (e) =>
    @element().setAttribute('published', !@isPublished())
    ObserveJS.XHR.send(@element())

  isPublished: =>
    @element().getAttribute('published') == 'true'

  refresh: (e) =>
    @element().setAttribute('published', e.State)

    if document.body.querySelector('main').classList.contains('titles')
      window.location.reload()

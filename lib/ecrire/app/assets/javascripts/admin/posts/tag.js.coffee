ObserveJS.bind 'Post.Tag', class
  loaded: =>
    @on 'change', @update
    @on 'tags:toggle', @refresh

  update: (e) =>
    xhr = new ObserveJS.XHR(@element())
    xhr.send()

  refresh: (e) =>
    @element().querySelector('input').checked = e.TagIncluded

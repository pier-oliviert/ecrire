ObserveJS.bind 'Post.Tag', class
  loaded: =>
    @on 'click', @submit

  submit: (e) =>
    @on 'tags:update', @remove
    ObserveJS.XHR.send(@element())

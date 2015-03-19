Joint.bind 'Post.Tag', class
  loaded: =>
    @on 'click', @submit

  submit: (e) =>
    @on 'tags:update', @remove
    Joint.XHR.send(@element())

Joint.bind 'Post.Tag', class
  loaded: =>
    @on 'click', @element().querySelector('svg'), @submit

  submit: (e) =>
    @on 'tags:update', @remove
    Joint.XHR.send(@element())

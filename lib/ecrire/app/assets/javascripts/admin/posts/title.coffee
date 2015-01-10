Joint.bind 'Posts.Title', class
  loaded: =>
    @on 'posts:update', @update

  update: (e) =>
    input = @element().querySelector('textarea.title')
    input.value = e.HTML.querySelector('textarea.title').value
    input.blur()


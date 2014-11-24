class Title
  loaded: =>
    @on 'posts:update', @update

  update: (e) =>
    input = @element().querySelector('textarea.title')
    input.value = e.HTML.querySelector('textarea.title').value
    input.blur()

Ethereal.Models.add Title, 'Posts.Title'

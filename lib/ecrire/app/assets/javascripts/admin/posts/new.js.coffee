class Post
  loaded: =>
    for el in @element().querySelectorAll('.transparent')
      el.classList.remove('transparent')

    @element().querySelector('input[type=text]').focus()

Ethereal.Models.add Post, 'Posts.New'

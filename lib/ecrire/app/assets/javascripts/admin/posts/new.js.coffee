Joint.bind 'Posts.New', class
  loaded: =>
    for el in @element().querySelectorAll('.transparent')
      el.classList.remove('transparent')

    @element().querySelector('input[type=text]').focus()


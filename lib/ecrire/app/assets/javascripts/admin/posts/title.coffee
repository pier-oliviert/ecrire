Joint.bind 'Posts.Title', class
  loaded: =>
    @title = @element().querySelector('input.title')
    @on 'posts:update', @update

  update: (e) =>
    @title.value = e.HTML
    @title.blur()

    if e.MessageHTML
      event = new CustomEvent('Editor:message', { bubbles: true})
      event.MessageHTML = e.MessageHTML
      @element().dispatchEvent(event)



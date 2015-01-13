Joint.bind 'Posts.Title', class
  loaded: =>
    @title = @element().querySelector('input.title')
    @on 'posts:update', @update

  update: (e) =>
    @title.value = e.HTML
    @title.blur()

    if e.Notice
      event = new CustomEvent('Editor:Messages:notice', { bubbles: true})
      event.message = e.Notice
      @element().dispatchEvent(event)



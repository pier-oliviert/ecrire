Joint.bind 'Posts.Title', class
  loaded: =>
    @on 'keydown', @submit
    @on 'posts:update', @update

  submit: (e) =>
    if e.keyCode == 13
      e.preventDefault()
      e.stopPropagation()
      @save()
      return

  update: (e) =>
    @title.value = e.HTML
    @title.blur()

    if e.MessageHTML
      event = new CustomEvent('Editor:message', { bubbles: true})
      event.MessageHTML = e.MessageHTML
      @element().dispatchEvent(event)

  save: (e) =>
    

ObserveJS.bind 'Post.Titles', class
  loaded: =>
    @on 'submit', @clear
    @when 'titles:update', @refresh
    @when 'titles:create', @refresh

    @element().querySelector('form input[type=text]').focus()


  clear: =>
    @element().querySelector('div.errors')?.remove()

  refresh: (e) =>
    if e.HTML?
      e = new CustomEvent('dialog:close', {bubbles: true})
      @element().dispatchEvent(e)
    else if e.ErrorHTML?
      @element().insertBefore(e.ErrorHTML, @element().querySelector('h2'))

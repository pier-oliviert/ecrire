ObserveJS.bind 'Post.Tags.Tag', class
  loaded: =>
    @on 'change', @submit
    @on 'tags:toggle', @update

  submit: (e) =>
    ObserveJS.XHR.send(@element())

  update: (e) =>
    oid = e.HTML.getAttribute('oid')
    if @element().getAttribute('oid') == oid
      activeElement = document.activeElement
      @element().parentElement.replaceChild(e.HTML, @element())
      if activeElement == @element()
        e.HTML.focus()


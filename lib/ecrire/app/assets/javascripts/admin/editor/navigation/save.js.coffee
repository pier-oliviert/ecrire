Joint.bind 'Editor.Save', class
  loaded: =>
    @element().setAttribute('disabled', 'disabled')
    @on 'Editor:updated', document, @update


  update: (e) =>

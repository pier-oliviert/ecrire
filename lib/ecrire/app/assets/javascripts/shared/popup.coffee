ObserveJS.bind 'Popup', class
  loaded: =>
    @on 'click', @element().querySelector('.close'), @remove
    @on 'click', document, @clicked
    @on 'keyup', document, @escaped

  clicked: (e) =>
    el = e.target
    while el != @element() && el?
      el = el.parentElement

    unless el?
      @remove()

  escaped: (e) =>
    if e.keyCode == 27
      @remove()

  remove: (e) =>
    @element().remove()

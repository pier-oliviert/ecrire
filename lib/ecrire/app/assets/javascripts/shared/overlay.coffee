ObserveJS.bind 'Overlay', class
  loaded: =>
    @on 'click', @clicked
    @when 'keyup', @escaped
    @on 'dialog:close', @remove

    @y = document.body.scrollTop
    main = document.body.querySelector('main')
    main.classList.add('overlayed')
    main.style.top = "-#{@y}px"
    document.body.scrollTop = 0

  clicked: (e) =>
    if e.target == @element()
      @remove()

  escaped: (e) =>
    if e.keyCode == 27
      @remove()

  remove: (e) =>
    main = document.body.querySelector('main')
    main.classList.remove('overlayed')

    @element().remove()

    window.scrollTo(0, @y)
    main.style.top = null
    @scrollTop = null

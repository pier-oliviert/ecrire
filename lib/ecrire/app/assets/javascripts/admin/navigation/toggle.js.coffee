ObserveJS.bind 'Navigation.Toggle', class
  loaded: =>
    @on 'click', @toggle

  toggle: (e) =>
    if @element().classList.toggle('active')
      Menu.style.marginTop = '0'
    else
      Menu.style.marginTop = ''

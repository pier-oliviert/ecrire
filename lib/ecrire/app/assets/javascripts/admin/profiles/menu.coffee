ObserveJS.bind 'Profiles.Menu', class
  loaded: =>
    @on 'profiles:show', @show

  show: (e) =>
    @element().appendChild(e.HTML)

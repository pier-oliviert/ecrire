Joint.bind 'Databases.Connect', class
  loaded: =>
    @on 'databases:create', @update

  update: (e) =>
    @element().insertBefore(e.HTML, @element().firstElementChild)


Joint.bind 'Editor.Code', class
  loaded: =>
    document.addEventListener 'keydown', @filter, true

  filter: (e) =>
    switch e.which
      when 13 then @linefeed(e)

  linefeed: (e) =>


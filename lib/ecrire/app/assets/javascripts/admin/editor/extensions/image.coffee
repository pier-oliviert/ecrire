Joint.bind 'Editor.Image', class
  loaded: =>
    @element().addEventListener 'dragover', @over
    @element().addEventListener 'dragleave', @cancel
    @element().addEventListener 'drop', @drop

  over: (e) =>
    e.preventDefault()
    @element().classList.add 'dropping'

  cancel: (e) =>
    e.preventDefault()
    @element().classList.remove 'dropping'

  drop: (e) =>
    e.preventDefault()
    @element().classList.remove 'dropping'



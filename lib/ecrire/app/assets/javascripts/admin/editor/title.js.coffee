Joint.bind 'Posts.Title.TextArea', class
  loaded: =>
    @on 'keyup', @resize
    @on 'change', @resize
    @on 'cut', @resize
    @on 'paste', @resize
    @on 'drop', @resize

    @on 'keydown', @submit


  resize: (e) =>
    style = window.getComputedStyle(@element())
    value = parseInt(style.getPropertyValue('font-size'))
    height = Math.ceil(@element().scrollHeight / value) * value
    @element().style.height = "#{height}px"

  submit: (e) =>
    return unless e.keyCode == 13
    Joint.XHR.send(@element().parentElement)

    e.preventDefault()
    e.stopPropagation()
    




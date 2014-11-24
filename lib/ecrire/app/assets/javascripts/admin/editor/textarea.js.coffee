class TextArea
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
    Ethereal.XHR.Form(@element().parentElement)

    e.preventDefault()
    e.stopPropagation()
    



Ethereal.Models.add TextArea, 'Posts.Title.TextArea'

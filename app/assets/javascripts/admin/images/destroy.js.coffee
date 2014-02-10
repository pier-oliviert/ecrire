class Destroy
  constructor: ($element) ->
    $element.on 'click', '.action.destroy.image', @toggle

  toggle: ->
    $this = $(this)
    fd = new FormData()
    fd.append('authenticity_token', $this.data('token'))
    $.ajax
      url: $this.attr('href'),
      type: 'delete',
      data: fd,
      processData: false
      contentType: false
    false


initializer = ($element) ->
  window.Editor.imagesDestroy = new Destroy($element)

if @Editor?
  @Editor.imagesDestroy = initializer
else
  $(document).on 'editor:loaded', (event, editor) ->
    window.Editor.imagesDestroy = initializer




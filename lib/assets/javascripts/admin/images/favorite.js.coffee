class Favorite
  constructor: ($element) ->
    $element.on 'click', '.action.favorite.image', @toggle

  toggle: ->
    $this = $(this)
    fd = new FormData()
    fd.append('authenticity_token', $this.data('token'))
    fd.append('admin_image[favorite]', $this.data('favorite'))
    $.ajax
      url: $this.attr('href'),
      type: 'patch',
      data: fd,
      processData: false
      contentType: false
    false


initializer = ($element) ->
  window.Editor.imagesFavorite = new Favorite($element)

if @Editor?
  @Editor.imagesFavorite = initializer
else
  $(document).on 'editor:loaded', (event, editor) ->
    window.Editor.imagesFavorite = initializer



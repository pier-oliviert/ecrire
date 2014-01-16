class ImageImporter
  configureEvent: (e) =>
    $el = $(e.toElement)
    event.dataTransfer.setData "text/plain", @tag($el)

  tag: ($el) ->
    "<img src='#{$el.data('url')}' alt='#{$el.data('alt')}' />"

if @Editor?
  @Editor.imageImporter = new ImageImporter()
else
  $(document).on 'editor:loaded', (event, editor) ->
    window.Editor.imageImporter = new ImageImporter()


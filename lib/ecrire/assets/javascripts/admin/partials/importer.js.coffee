class PartialImporter
  configureEvent: (e) =>
    $el = $(e.target)
    e.dataTransfer.setData "text/plain", @tag($el)

  tag: ($el) ->
    "<link rel='partial' href='#{$el.data('url')}' />"

  showPreview: (e) ->
    $("#previewlink").click()

if @Editor?
  @Editor.partialImporter = new PartialImporter()
else
  $(document).on 'editor:loaded', (event, editor) ->
    window.Editor.partialImporter = new PartialImporter()


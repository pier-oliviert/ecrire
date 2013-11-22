$(document).on "DOMContentLoaded page:load", ->
  if $("[class*=_post]").length > 0
    window.Editor = new Editor()

    $("#post_editing_options").on "click", "a", ->
      $el = $("#" + $(this).attr("binding"))
      $("form .editor").not($el).hide()
      $el.show()

class Editor
  constructor: (opts) ->
    elements = {
      $content: $("#post_content"),
      $stylesheet: $("#post_stylesheet"),
      $preview: $("#content_preview > .preview"),
      title: new Title()
    }
    @listen(elements)

  listen: (elements) ->
    updatePreview = ->
      elements.$preview.html elements.$content.val()
      elements.$preview.siblings("style").text elements.$stylesheet.val()

    elements.$content.get(0).addEventListener 'input', updatePreview
    elements.$stylesheet.get(0).addEventListener 'input', updatePreview

    updatePreview()


class Title
  constructor: ->
    @elements = {
      $wrapper: $("#post_title_wrapper"),
      $title: $("#post_title"),
      $slug: $("#post_slug")
    }

    @listen(@elements)

  listen: (elements) ->
    elements.$wrapper.on 'click', 'a.toggle', =>
      @toggle(elements)

  toggle: (elements) ->
    elements.$wrapper.toggleClass("slug")
    elements.$title.add(elements.$slug).toggle()


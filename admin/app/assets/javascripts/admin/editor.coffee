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
      $preview: $("#content_preview"),
      title: new Title()
    }
    @listen(elements)

  listen: (elements) ->
    $textareas = elements.$content.add(elements.$preview)
    updatePreview = ->
      elements.$preview.children(".preview").html elements.$content.val()
      elements.$preview.children("style").text elements.$stylesheet.val()

    updateScroll = ->
      $this = $(this)
      $textareas.not($this).scrollTop $this.scrollTop()

    elements.$content.get(0).addEventListener 'input', updatePreview
    elements.$content.get(0).addEventListener 'scroll', updateScroll
    elements.$preview.get(0).addEventListener 'scroll', updateScroll
    elements.$stylesheet.get(0).addEventListener 'input', updatePreview

    elements.$content.get(0)

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


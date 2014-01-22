$(document).on "DOMContentLoaded page:load", ->
  if $(".editor.form").length > 0
    window.Editor = new Editor()

    $(".editor.options").on "click", "a.content", ->
      $this = $(this)
      $this.siblings(".active").removeClass("active")
      $this.addClass("active")
      $el = $($this.attr("binding"))
      $(".content > .editor").not($el).hide()
      $el.show()

    $(".preview.options").on 'click', 'a', ->
      $this = $(this)
      $this.siblings(".active").removeClass("active")
      $this.addClass("active")

    $(".preview.options #previewLink").on 'click', (e) ->
      window.Editor.sidebarContent.show('preview')

    $(document).trigger('editor:loaded', window.Editor)

class Editor
  constructor: (opts) ->
    previews = {
      $HTMLContent: $("#articleHTMLContent"),
      $StylesheetContent: $("#articleStylesheetContent"),
      $ScriptContent: $("#articleScriptContent"),
    }

    inputs = {
      $HTMLContent: $("#formContentInput"),
      $StylesheetContent: $("#formStylesheetInput"),
      $ScriptContent: $("#formScriptInput")
    }

    @title =  new Title()
    @menu = new SaveButton($(".possible.save.actions"))
    @sidebarContent = new SideBarContent($("#editorSideContent"))
    @listen(inputs, previews)

  listen: (inputs, previews) ->
    sidebarContent = @sidebarContent

    updatePreview = ->
      previews.$HTMLContent.html inputs.$HTMLContent.val()
      previews.$HTMLContent.find('link[rel="partial"]').each ->
        $link = $(this)
        $.get $link.attr('href'), (data) ->
          $link.replaceWith(data)

      previews.$StylesheetContent.text inputs.$StylesheetContent.val()
      $ScriptContent = $('<script>')
      $ScriptContent.text inputs.$ScriptContent.val()
      previews.$ScriptContent.replaceWith $ScriptContent
      previews.$ScriptContent = $ScriptContent
      Prism.highlightAll()

    inputs.$HTMLContent.get(0).addEventListener 'input', updatePreview
    inputs.$StylesheetContent.get(0).addEventListener 'input', updatePreview
    inputs.$ScriptContent.get(0).addEventListener 'input', updatePreview

    inputs.$HTMLContent.get(0).addEventListener 'scroll', ->
      sidebarContent.scrollTo(this.scrollTop / this.scrollHeight)

    updatePreview()

class SideBarContent
  constructor: ($wrapper) ->
    @$wrapper = $wrapper
    @templates = {}
    @templates['preview'] = $('#contentPreviewContainer')

  show: (name) =>
    @$wrapper.children().detach()
    @$wrapper.html(@templates[name])

  add: (name, dom) =>
    if @templates[name]? 
      raise "Can't add template because another template is assigned to #{name}"
    @templates[name] = dom
    return this

  scrollTo: (percent) ->
    @$wrapper.scrollTop(percent * @$wrapper.get(0).scrollHeight)


class Title
  constructor: ->
    @elements = {
      $wrapper: $(".title.wrapper"),
      $title: $(".title.wrapper > .input"),
      $slug: $("#post_slug")
    }

    @listen(@elements)

  listen: (elements) ->
    elements.$wrapper.on 'click', 'a.toggle', =>
      @toggle(elements)

  toggle: (elements) ->
    elements.$wrapper.toggleClass("slug")
    elements.$title.add(elements.$slug).toggle()

class SaveButton
  constructor: ($el) ->
    $el.on 'click', '.arrow', ->
      $el.find("button[value=publish]").toggle()


$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  if $('form.post.editor').hasClass('autosave')
    setTimeout autoSave, 250

  listenForUpdates()
  livePreview()
  autoScroll()
  editorField().focus()
  toggleSettings()

toggleSettings = ->
  $header = $('aside.preview header')
  $content = $header.children('div.content').detach()
  $header.on 'click', 'p.handler', ->
    $header.toggleClass('expanded')
    if $header.hasClass('expanded')
     $header.find('p.handler').before($content)
    else
      $content.detach()



preventSubmissions = ->
  $("form").on "submit", (e) ->
    return false unless e.target.id == 'postEditor'
  preventSubmissions

listenForUpdates = ->
  listenForUpdates

autoSave = ->
  setTimeout autoSave, 250
  $form = $("form.editor")
  return autoSave unless $form.data('outdated')

  $status = $form.find('nav.post p.status')
  sendForm($form, $form.attr('method'))
  $form.data('outdated', false)
  autoSave


editorField = ->
  $form = $('form.editor')
  editorField.focus = ->
    $("form.editor textarea.active").focus()

  $('nav.post ol.menu li[target]').on 'click', ->
    $this = $(this)
    $form.find('textarea').add('fieldset')
      .removeClass('active')
      .filter(".#{this.attributes.getNamedItem('target').value}")
      .addClass('active')
    $this.addClass('active').siblings().removeClass('active')
    editorField.focus()
  editorField

autoScroll = ->
  $preview = $('aside.preview')
  $('form.post.editor textarea.content').on 'scroll', ->
    return unless $(this).hasClass('active')
    percent = this.scrollTop / (this.scrollHeight - this.clientHeight)
    preview = $preview.get(0)
    preview.scrollTop = (preview.scrollHeight - this.clientHeight) * percent
  autoScroll

livePreview = ->
  $form = $('form.editor')
  $form.find('section.textareas > textarea').on 'input', ->
    $form.data('outdated', true)
    $preview = $form
    $element = $form.siblings("aside.preview").children(".#{this.attributes.getNamedItem('target').value}")
    $element.html this.value
  livePreview

transferComplete = (e) ->
  jQuery.globalEval(e.target.responseText)

window.sendForm = ($form, method) ->
  $actions = $('div.actions')
  $actions.children('span').addClass('loading')
  $actions.children('button').attr('disabled', true)
  data = new FormData($form.get(0))
  request = new XMLHttpRequest()
  request.open method, $form.attr('action') + '.js'
  request.addEventListener("load", transferComplete, false);
  request.send(data)
  request

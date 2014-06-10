$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  if $('form.post.editor').hasClass('autosave')
    setTimeout autoSave, 250
    autoSaveSettings()
  else
    manuallySaveSettings()

  preventSubmissions()
  listenForUpdates()
  livePreview()
  toggleSettings()
  autoScroll()
  editorField().focus()


preventSubmissions = ->
  $("form").on "submit", (e) ->
    return false unless e.target.id == 'postEditor'
  preventSubmissions

listenForUpdates = ->
  $title = $('nav.admin.options > span.title')
  $('nav').on 'title:updated', (e, title) ->
    $title.text(title)
  listenForUpdates

manuallySaveSettings = ->
  $('section.post.settings').on 'click', 'button.save', ->
    $form = $(this).parents('form')
    request = sendForm($form)
    request.addEventListener("load", toggleSettings.close, false);
  manuallySaveSettings

autoSaveSettings = ->
  $settings = $('section.post.settings')
  $settings.on 'input', 'input', ->
    $form = $(this).parents('form')
    sendForm($form)
  autoSaveSettings

autoSave = ->
  setTimeout autoSave, 250
  $form = $("form.editor")
  return autoSave unless $form.data('outdated')

  $status = $form.find('nav.post p.status')
  sendForm($form)
  $form.data('outdated', false)
  autoSave


toggleSettings = ->
  $settings = $("section.post.settings").detach().removeClass('hidden').css('visibility', 'hidden')
  $closeBtn = $settings.find('div.actions > button')

  toggleSettings.close = ->
    return if $closeBtn.attr('disabled')
    $parent = $settings.parent()
    $parent.removeClass('settings').one 'transitionend', ->
      $settings.detach()
      $parent.html($items.fadeIn('fast'))
    false

  key 'escape', toggleSettings.close
  $settings.on 'click', 'button.close', toggleSettings.close

  $items = $('nav.admin.options').children()
  $('nav.admin').on 'click', 'a.settings', ->
    $this = $(this)
    $items.fadeOut 'fast', ->
      $parent = $this.parent()
      $parent.addClass('settings')
      $items.detach()
      $parent.html $settings
      $settings.css('visibility', 'visible')
  toggleSettings

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
  $form.children('textarea').on 'input', ->
    $form.data('outdated', true)
    $preview = $form
    $element = $form.siblings("aside.preview").children(".#{this.attributes.getNamedItem('target').value}")
    $element.html this.value
  livePreview

transferComplete = (e) ->
  jQuery.globalEval(e.target.responseText)

sendForm = ($form) ->
  $actions = $('div.actions')
  $actions.children('span').addClass('loading')
  $actions.children('button').attr('disabled', true)
  data = new FormData($form.get(0))
  request = new XMLHttpRequest()
  request.open 'PUT', $form.attr('action') + '.js'
  request.addEventListener("load", transferComplete, false);
  request.send(data)
  request

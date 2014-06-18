$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  if $('form.post.editor').hasClass('autosave')
    autoSave()
  else
    manuallySave()

manuallySave = ->
  $('post.settings').on 'click', 'button.save', ->
    $form = $(this).parents('form')
    request = sendForm($form)
    request.addEventListener("load", toggleSettings.close, false);
    manuallySave

autoSave = ->
  $form = $('form.title.settings')
  $form.on 'input', 'input', ->
    $form = $(this).parents('form')
    sendForm($form)
    autoSave

sendForm = ($form) ->
  window.sendForm($form, $form.attr('method'))


$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  if $('form.post.editor').hasClass('autosave')
    autoSave()
  else
    manuallySave()

updateTitle = ->
  $('aside.preview p.title')

manuallySave = ->
  $('post.settings').on 'click', 'button.save', ->
    $form = $(this).parents('form')
    request = sendForm($form)
    request.addEventListener("load", updateTitle, false);
    manuallySave

autoSave = ->
  $form = $('form.title')
  $form.on 'input', 'input', ->
    console.log 'here'
    $form = $(this).parents('form')
    sendForm($form)
    false
  autoSave

sendForm = ($form) ->
  window.sendForm($form, $form.attr('method'))


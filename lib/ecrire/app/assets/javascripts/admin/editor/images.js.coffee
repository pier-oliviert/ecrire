$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 

  form()
  observer().observe($('article.content').get(0), {
    childList: true
  })
  replaceEmptyImagesWithForm()
  clickableForm()

clickableForm = ->
  $('article.content').on 'click', 'form.image div.wrapper', (e) ->
    $(this).siblings('input[type=file]').trigger('click', e)
    false

images = ->
  $('aside.preview img').filter(':not([src])')

form = ->
  $element = $('aside.preview form.image').detach()
  form = ->
    $element
  
replaceEmptyImagesWithForm = () ->
  images().each ->
    $form = form().clone()
    $form.on 'change', 'input[type=file]', ->
      sendFile($(this).parents('form').get(0))

    $(this).replaceWith($form)

    element = $form.get(0)
    element.ondragover = ->
      $(this).addClass('dropping')
      false

    element.ondragleave = element.ondragend = (e) ->
      $(this).removeClass('dropping')
      false

    element.ondrop = (e) ->
      $(this).removeClass('dropping')
      sendFile(this, e.dataTransfer.files[0])
      false

observer = (el, config) ->
  obs = new MutationObserver replaceEmptyImagesWithForm
  observer = ->
    obs
  obs

sendFile = (form, file) ->
  xhr = new XMLHttpRequest()

  form.classList.add 'replaceable'

  formData = new FormData(form)
  if file?
    formData.append('admin_image[file]', file)

  xhr.open(form.method, form.action)

  xhr.onload = (e) =>
    result = $.globalEval(xhr.responseText)

  xhr.send(formData)


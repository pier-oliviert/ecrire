$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 

  form()
  observer().observe($('article.content').get(0), {
    childList: true
  })
  replaceEmptyImagesWithForm()
  clickableForm()
  enableHeader()

enableHeader = ->
  $header = $('aside.preview header')
  droppable($header.get(0))
  $header.on 'change', 'form.image input[type=file]', ->
    $form = $(this).parents('form')
    sendFile($form.get(0))
    false


droppable = (element) ->
  element.ondragover = ->
    $(this).addClass('dropping')
    false

  element.ondragleave = element.ondragend = (e) ->
    $(this).removeClass('dropping')
    false

  element.ondrop = (e) ->
    $this = $(this)
    form = $this.find('form.image').get(0)
    $this.removeClass('dropping')
    sendFile(form, e.dataTransfer.files[0])
    false

clickableForm = ->
  $('aside.preview').on 'click', 'form.image p', (e) ->
    $this = $(this)
    $form = $this.parents('form.image')
    $form.find('input[type=file]').trigger('click', e)
    false

images = ->
  $('aside.preview img').filter(':not([src])')

form = ->
  $element = $('aside.preview form.image:not(.header)').detach()
  form = ->
    $element
  
replaceEmptyImagesWithForm = () ->
  images().each ->
    $form = form().clone()
    $form.on 'change', 'input[type=file]', ->
      sendFile($(this).parents('form').get(0))

    $(this).replaceWith($form)

    form = $form.get(0)
    droppable(form, form)

observer = (el, config) ->
  obs = new MutationObserver replaceEmptyImagesWithForm
  observer = ->
    obs
  obs

sendFile = (form, file) ->
  xhr = new XMLHttpRequest()

  form.classList.add 'replaceable'

  formData = new FormData(form)
  formData.append('authenticity_token', $('meta[name=csrf-token]').attr('content'))
  if file?
    formData.append('admin_image[file]', file)

  xhr.open(form.method, form.action)

  xhr.onload = (e) =>
    result = $.globalEval(xhr.responseText)

  xhr.send(formData)


$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  toggle()
  clearOnSubmit()

clearOnSubmit = ->
  $('form.labels.new').on 'ajax:complete', ->
    $(this).find('input.name').val('')

toggle = ->
  $('section.labels form.labels.new').on 'focus blur', 'input', ->
    $(this).parents('fieldset').toggleClass('focus')

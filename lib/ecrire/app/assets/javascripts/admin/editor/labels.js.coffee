$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  toggle()

toggle = ->
  $('section.labels form.labels.new').on 'focus blur', 'input', ->
    $(this).parents('fieldset').toggleClass('focus')

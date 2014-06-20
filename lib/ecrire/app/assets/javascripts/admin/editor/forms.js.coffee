$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  toggleFocusOnForm()

toggleFocusOnForm = ->
  $('aside.preview header').on 'focus blur', 'input', ->
    $(this).parents('form').toggleClass('focus')


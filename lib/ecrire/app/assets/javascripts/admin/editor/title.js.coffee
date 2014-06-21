$(document).on "DOMContentLoaded page:load", ->
  return unless $('body.edit.posts').length > 0 
  $('aside.preview header').on 'title:updated', (e, title) ->
    $('aside.preview p.title').text(title).focus()

  $('aside.preview').on 'submit', 'form.title', ->
    $(this).find('input:focus').blur()

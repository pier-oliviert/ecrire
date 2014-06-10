$(document).on "DOMContentLoaded page:load", ->
  $('form.post.new.title fieldset.transparent').removeClass('transparent')
  $('form.post.new.title input').on 'focus', ->
    $(this).parent().siblings('p').removeClass('transparent')

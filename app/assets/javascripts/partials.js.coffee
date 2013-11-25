$(document).on 'DOMContentLoaded page:load', ->
  $("link[rel='partials']").each ->
    $link = $(this)
    $.get $link.attr('href'), (data) ->
      $link.replaceWith(data)

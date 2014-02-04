$(document).on 'DOMContentLoaded page:load', ->
  $("link[rel='partial']").each ->
    $link = $(this)
    $.get $link.attr('href'), (data) ->
      $link.replaceWith(data)

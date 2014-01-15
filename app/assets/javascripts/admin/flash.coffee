$(document).on "click", ".dismiss", ->
  $(this).parents(".container").fadeOut("fast", -> $(this).remove())

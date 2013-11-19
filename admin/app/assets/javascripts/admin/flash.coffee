$(document).on "click", ".flash .dismiss", ->
  $(this).parents(".flash").fadeOut("fast")

//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./vendor
//

key('ctrl+l', function() {
  $.getScript("/admin")
})

$(document).on('click', 'nav.menu.extended a.drafts', function(e) {
  $nav = $(this).parents('nav')
    .removeClass('extended')

  $nav
    .one('transitionend', function() {
      $nav.children('section.drafts').remove()
    })

  $nav
    .children('a.drafts').attr('data-remote', true)

  return false
})

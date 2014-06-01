//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require xss_protection
//= require_tree ./vendor
//

key('ctrl+l', function() {
  $.getScript("/admin")
})

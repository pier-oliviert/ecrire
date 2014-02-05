//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require xss_protection
//= require vendor/keymaster
//
//= require base
//

key 'ctrl+l', ->
  $.getScript("/admin")

$(document).on "DOMContentLoaded page:load", ->
  if $(".hn-share-button").length > 0
    g = document.createElement("script")
    s = document.getElementsByTagName("script")[0]
    g.src = '//hnbutton.appspot.com/static/hn.min.js'
    s.parentNode.insertBefore(g, s)


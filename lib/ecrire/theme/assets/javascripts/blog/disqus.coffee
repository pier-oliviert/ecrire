$(document).on "DOMContentLoaded page:load", ->
  if $("#disqus_thread").length > 0
    disqus_shortname = 'pothibo';

    dsq = document.createElement('script')
    dsq.type = 'text/javascript'
    dsq.async = true
    dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js'
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);

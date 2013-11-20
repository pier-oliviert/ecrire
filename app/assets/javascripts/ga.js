var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-16312790-3']);
_gaq.push(['_setDomainName', 'pothibo.com']);
_gaq.push(['_trackPageview']);

setTimeout(function() {
  var unbounce = function() {
    document.removeEventListener('scroll', unbounce)
    _gaq.push(['_trackEvent', 'scroll', 'read']);
  }

  document.addEventListener('scroll', unbounce) 
}, 5000);

(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

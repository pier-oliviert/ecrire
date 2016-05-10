//= require turbolinks
//= require observejs
//= require written
//= require_tree ./admin
//= require_tree ./vendor
//= require_tree ./shared

// Not loading this with ObserveJS cuz the layout
// would require to declare a class for it to load.
var script = document.getElementsByTagName('script');

script = script[script.length - 1];

if (script) {
  Prism.filename = script.src;

  if (document.addEventListener && !script.hasAttribute('data-manual')) {
    document.addEventListener('DOMContentLoaded', Prism.highlightAll);
    document.addEventListener('page:load', Prism.highlightAll);
  }
}

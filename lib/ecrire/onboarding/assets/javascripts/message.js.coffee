Joint.bind 'Message', class
  loaded: =>
    @on 'animationend', @remove
    @on 'webkitAnimationEnd', @remove
    @on 'oAnimationEnd', @remove
    @on 'MSAnimationEnd', @remove

  remove: =>
    @element().remove()

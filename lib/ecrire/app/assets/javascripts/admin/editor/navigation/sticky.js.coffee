Joint.bind 'Post.Sticky', class
  loaded: =>
    @on 'scroll', document, @scrolled

  scrolled: (e) =>
    top = @element().getBoundingClientRect().top
    if top < 0
      @element().style.paddingTop = "#{Math.abs(top)}px"
    else
      @element().style.paddingTop = ''


ObserveJS.bind 'Posts.Filter.Tags', class
  loaded: =>
    @on 'tags:index', @show
    @on 'click', @action
    @element().appendChild(@retrieve('svg.placeholder'))

  show: (e) =>
    document.body.appendChild(e.HTML)
    @on 'click', e.HTML, @select

  select: (e) =>
    span = @retrieve('span.tag')
    span.textContent = e.target.textContent
    @retrieve('svg.placeholder').remove()
    @element().appendChild(span)
    @element().appendChild(@retrieve('svg.clear'))
    @element().setAttribute('tid', e.target.getAttribute('oid'))
    @element().classList.add 'tagged'
    document.querySelector("[as='Overlay']").instance.remove()
    document.querySelector("[as='Posts.Filter']").instance.search()

  action: =>
    if @element().classList.contains('tagged')
      @retrieve('svg.clear').remove()
      @retrieve('span.tag').remove()
      @element().appendChild(@retrieve('svg.placeholder'))
      @element().classList.remove('tagged')
      @element().removeAttribute('tid')
    else
      xhr = new ObserveJS.XHR(@element())
      xhr.send()
    document.querySelector("[as='Posts.Filter']").instance.search()

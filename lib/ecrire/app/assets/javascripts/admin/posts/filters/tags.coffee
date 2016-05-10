ObserveJS.bind 'Posts.Filter.Tags', class
  loaded: =>
    @on 'tags:index', @show
    @on 'click', @action
    @when 'tags:filter:list:selected', @select
    @element().appendChild(@template('svg.placeholder'))

  show: (e) =>
    e.HTML.querySelector('ul')?.setAttribute('as', 'Tags.Filter.List')
    document.body.appendChild(e.HTML)

  select: (e) =>
    el = e.detail
    input = @element().querySelector('input[type=hidden]')
    span = @template('span.tag')
    span.textContent = el.dataset.name
    input.value = el.getAttribute('oid')

    @element().querySelector('svg.placeholder')?.remove()
    @element().appendChild(@template('svg.clear'))
    @element().appendChild(span)
    @element().classList.add 'tagged'

    document.querySelector("[as='Overlay']").instance.remove()

    @changed(input)

  action: (e) =>
    clear = @element().querySelector('svg.clear')
    if clear? && clear.contains(e.target)
      clear.remove()
      @element().querySelector('span')?.remove()
      @element().appendChild(@template('svg.placeholder'))
      @element().classList.remove 'tagged'
      input = @element().querySelector('input[type=hidden]')
      input.value = null
      @changed(input)
    else
      xhr = new ObserveJS.XHR(@element())
      xhr.send()


  changed: (el) =>
    event = new Event('input')
    el.dispatchEvent(event)


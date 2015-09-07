ObserveJS.bind 'Posts.Filter.Tags', class
  loaded: =>
    @on 'tags:index', @show
    @on 'click', @action
    @element().appendChild(@retrieve('svg.placeholder'))

  show: (e) =>
    document.body.appendChild(e.HTML)
    @on 'click', e.HTML, @select

  select: (e) =>
    el = e.target
    while el && !(el instanceof HTMLLIElement)
      el = el.parentElement

    return unless el?

    input = @element().querySelector('input[type=hidden]')
    span = @retrieve('span.tag')
    span.textContent = el.textContent
    input.value = el.getAttribute('oid')

    @retrieve('svg.placeholder').remove()
    @element().appendChild(span)
    @element().appendChild(@retrieve('svg.clear'))
    @element().classList.add 'tagged'

    document.querySelector("[as='Overlay']").instance.remove()

    @changed(input)

  action: =>
    input = @element().querySelector('input[type=hidden]')
    if @element().classList.contains('tagged')
      @retrieve('svg.clear').remove()
      @retrieve('span.tag').remove()
      @element().appendChild(@retrieve('svg.placeholder'))
      @element().classList.remove('tagged')
      input.value = null
      @changed(input)
    else
      xhr = new ObserveJS.XHR(@element())
      xhr.send()


  changed: (el) =>
    event = new Event('input')
    el.dispatchEvent(event)


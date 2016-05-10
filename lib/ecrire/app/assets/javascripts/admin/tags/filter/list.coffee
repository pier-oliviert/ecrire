ObserveJS.bind 'Tags.Filter.List', class
  loaded: =>
    @on 'click', @select

  select: (e) =>
    el = e.target
    while el && !(el instanceof HTMLLIElement)
      el = el.parentElement

    return unless el?

    event = new CustomEvent('tags:filter:list:selected', {
      bubbles: true
      detail: el
    })

    @element().dispatchEvent(event)



ObserveJS.bind 'Posts.Filter', class
  loaded: =>
    for el in @element().elements
      switch el.type
        when 'text', 'hidden' then @on 'input', el, @search

    document.querySelector('input.search').focus()

  search: =>
    xhr = new ObserveJS.XHR(@element())
    for el in @element().elements
      switch el.type
        when 'text', 'hidden' then xhr.data.set(el.name, el.value) if el.value.length > 0
    xhr.send()

    document.querySelector('input.search').focus()


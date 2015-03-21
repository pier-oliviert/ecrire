ObserveJS.bind 'Post.Delete', class
  loaded: =>
    @on 'change', @element().querySelector('input[type=checkbox]'), @toggle

  toggle: (e) =>
    button = e.target.parentElement
    if e.target.checked
      button.removeAttribute('disabled')
    else
      button.setAttribute('disabled', 'disabled')

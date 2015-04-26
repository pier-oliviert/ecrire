ObserveJS.bind 'Posts.Filter', class
  loaded: =>
    @on 'input', @search
    @on 'posts:index', @update

    @element().querySelector('input.search').focus()

  search: =>
    xhr = new ObserveJS.XHR(@element())
    xhr.data.set 'q', @element().querySelector('input').value
    tags = @element().querySelector("[as='Posts.Filter.Tags']")
    if tags.hasAttribute('tid')
      xhr.data.set 'tid', tags.getAttribute('tid')

    xhr.send()

  update: (e) =>
    posts = @element().nextElementSibling
    posts.innerHTML = e.HTML.innerHTML

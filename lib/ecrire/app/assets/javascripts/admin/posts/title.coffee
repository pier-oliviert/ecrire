Joint.bind 'Post.Title', class
  loaded: =>
    @on 'keydown', @enter
    @observer = new MutationObserver(@modified)
    @observer.settings = {
      childList: true,
      subtree: true,
    }
    @input = @element().querySelector('div.input')
    @errors = @element().querySelector('ul.errors')
    @observe()
    @on 'titles:update', @update
    @on 'titles:create', @update
    @input.focus()

  dismiss: =>
    @element().parentElement.remove()

  update: (e) =>
    if e.Errors
      @errors.appendChild(error) for error in e.Errors
    else
      @dismiss()

  enter: (e) =>
    if e.keyCode == 13
      @errors.innerHTML = ''
      e.stopPropagation()
      e.preventDefault()
      @save()
      return

  modified: (observedMutations) =>
    @observer.disconnect()
    @input.innerHTML = @input.textContent
    @observe()

  observe: =>
    @observer.observe @input, @observer.settings

  save: =>
    xhr = new Joint.XHR(@element())
    xhr.data.set '[title]name', @input.textContent
    xhr.send()

class Popup
  loaded: =>
    @on 'posts:index', @show

  show: (e) =>
    document.body.appendChild(e.HTML)
    @on 'keyup', document, @escaped
    @on 'click', document, @clicked

  clicked: (e) =>
    el = e.target
    while el && !el.classList.contains('popup')
      el = el.parentElement

    unless el?
      @remove()

  escaped: (e) =>
    if e.keyCode == 27
      @remove()

  remove: (e) =>
    document.removeEventListener('keyup')
    document.removeEventListener('click')
    popup = document.body.querySelector('.popup')
    return unless popup?
    if popup.parentElement.classList.contains('overlay')
      popup.parentElement.remove()
    else
      popup.remove()

Ethereal.Models.add Popup, 'Posts.Popup'

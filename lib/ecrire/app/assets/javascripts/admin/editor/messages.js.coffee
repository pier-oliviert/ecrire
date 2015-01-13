Joint.bind 'Editor.Messages', class
  timeout: 2000
  loaded: =>
    @on 'Editor:message', document, @notice
    @on 'transitionend', @dismiss

  notice: (e) =>
    el = e.MessageHTML
    @element().appendChild el
    el.timeoutID = setTimeout @fade, @timeout, el
    @on 'click', @element().querySelector('span:last-child'), @fade
    

  fade: (el) =>
    unless el instanceof HTMLDivElement
      el = el.target.parentElement
      clearTimeout(el.timeoutID)
    el.classList.add('fade')

  dismiss: (e) =>
    @element().innerHTML = ''


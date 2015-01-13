Joint.bind 'Editor.Messages', class
  loaded: =>
    @on 'Editor:Messages:notice', document, @notice
    @on 'Editor:Messages:error', document, @error

  error: (e) =>
    @dismiss()

  notice: (e) =>
    @element().innerText = e.message

  dismiss: (e) =>
    @element().innerText = null


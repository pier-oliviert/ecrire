ObserveJS.bind 'Database.Information', class
  loaded: =>
    @on 'input', @element().querySelector('form'), @update

  update: =>
    name = @element().querySelector('input.name').value
    user = @element().querySelector('input.user').value
    password = @element().querySelector('input.password').value

    for el in @element().querySelectorAll('.terminal .user')
      el.textContent = user

    for el in @element().querySelectorAll('.terminal .name')
      el.textContent = name

    for el in @element().querySelectorAll('.terminal .password')
      el.textContent = password

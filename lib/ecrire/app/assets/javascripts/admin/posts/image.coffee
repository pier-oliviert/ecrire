Joint.bind 'Post.Header', class
  loaded: =>
    @on 'dragover', @over
    @on 'dragleave', @cancel
    @on 'drop', @drop
    @on 'click', @element().querySelector('div'), @open
    input = @element().querySelector('input[type=file]')
    @on 'change', input, @submit

    @on 'images:update', @update
    @on 'images:destroy', @clear
    @refresh()

  open: (e) =>
    @element().querySelector('input[type=file]').click()

  over: (e) =>
    e.preventDefault()
    @element().classList.add 'dropping'

  cancel: (e) =>
    e.preventDefault()
    @element().classList.remove 'dropping'

  drop: (e) =>
    @element().classList.remove 'dropping'
    e.preventDefault()
    form = @element().querySelector('form.update')
    xhr = new Joint.XHR(form)
    xhr.data.set 'image[file]', e.dataTransfer.files[0]
    xhr.send()

  submit: (e) =>
    Joint.XHR.send(e.target.form)

  clear: (e) =>
    @element().style.backgroundImage = null
    @refresh()

  update: (e) =>
    @element().style.backgroundImage = "url(#{e.headerURL})"
    @refresh()


  refresh: =>
    clearForm = @element().querySelector('form.clear')
    p = @element().querySelector('p')
    @refresh = =>
      if @element().style.backgroundImage.length > 0
        p.style.visibility = 'hidden'
        clearForm.style.visibility = 'visible'
      else
        clearForm.style.visibility = 'hidden'
        p.style.visibility = 'visible'

    @refresh()

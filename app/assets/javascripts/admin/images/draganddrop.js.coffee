class DragAndDrop
  constructor: (element) ->
    @element = element
    @$message = $(element.children)
    @listenTo(@element)

  listenTo: (holder) =>
    self = this
    holder.ondragover = ->
      $(this).addClass 'hover'
      false

    holder.ondragend = holder.ondragleave = ->
      $(this).removeClass 'hover'
      false

    holder.ondrop = (e) ->
      $(this).removeClass 'hover'
      e.preventDefault()
      if e.dataTransfer.files.length > 0
        self.hideMessage()
        self.upload self.readAndPreview(e.dataTransfer.files)

    
  hideMessage: ->
    @$message.hide()

  showMessage: ->
    @$message.appendTo($(@element).empty()).show()

  readAndPreview: (files) ->
    # Let's work with only one file for now.
    file = files[0]
    reader = new FileReader()
    reader.onload = @preview
    reader.readAsDataURL(file)
    file

  preview: (e) =>
    $div = $("<div class='loading' id='submittingImageProgress'>")
    $div.get(0).style.backgroundImage = "url('#{e.target.result}')"

    $progress = $("<div class='overlay'><progress value=0></progress></div>")
    $div.append($progress)
    $(@element).prepend($div)

  upload: (file) ->
    xhr = new XMLHttpRequest()

    form = document.getElementById("imageForm")

    formData = new FormData(form)
    formData.append('file', file)

    xhr.open(form.method, form.action)

    xhr.onload = (e) =>
      script = document.createElement('script')
      script.text = $.globalEval(xhr.responseText)
      document.head.appendChild( script ).parentNode.removeChild( script );

    xhr.upload.onprogress = (e) ->
      if e.lengthComputable
        complete = (e.loaded / e.total * 100 || 0);
        $("#submittingImageProgress progress").val(complete)

    xhr.send(formData)


initializer = (element) ->
  window.Editor.imageDropPad = new DragAndDrop(element)

if @Editor?
  @Editor.imageDropPad = initializer
else
  $(document).on 'editor:loaded', (event, editor) ->
    editor.imageDropPad = initializer



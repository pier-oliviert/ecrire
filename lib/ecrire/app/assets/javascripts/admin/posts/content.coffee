ObserveJS.bind 'Editor.Content', class
  loaded: =>
    Written.Parsers.get('pre').highlightWith (element) ->
      Prism.highlightElement(element, false)

    Written.Parsers.get('code').highlightWith (element) ->
      Prism.highlightElement(element, false)

    if @element().dataset.bucket?
      window.AWS = {
        bucket: @element().dataset.bucket,
        accessKey: @element().dataset.accessKey,
        policy: @element().dataset.policy,
        signature: @element().dataset.signature
      }

    @written = new Written(this.element())
    @written.initialize()

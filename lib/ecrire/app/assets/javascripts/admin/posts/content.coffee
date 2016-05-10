ObserveJS.bind 'Editor.Content', class
  loaded: =>
    code = Written.Parsers.Block.get('Code').prototype
    code.highlight = (element) ->
      Prism.highlightElement(element, false)

    code = Written.Parsers.Inline.get('Code').prototype
    code.highlight = (element) ->
      Prism.highlightElement(element, false)

    if @element().dataset.bucket?
      uploader = new Written.Uploaders.AWS({
        bucket: @element().dataset.bucket,
        namespace: @element().dataset.namespace,
        url: @element().dataset.url,
        accessKey: @element().dataset.accessKey,
        policy: @element().dataset.policy,
        signature: @element().dataset.signature
      })

      Written.Parsers.Block.get('Image').uploader(uploader)
    @written = new Written(this.element())
    @written.initialize()

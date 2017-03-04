#= require 'written/attachments/image'

ObserveJS.bind 'Editor.Content', class
  loaded: =>
    if @element().dataset.bucket?
      window.AWS = {
        bucket: @element().dataset.bucket,
        accessKey: @element().dataset.accessKey,
        policy: @element().dataset.policy,
        signature: @element().dataset.signature
      }

    @written = new Written(this.element())

    @written.parsers.get('pre')?.highlightWith (element) ->
        Prism.highlightElement(element, false)

    @written.parsers.get('code')?.highlightWith (element) ->
        Prism.highlightElement(element, false)


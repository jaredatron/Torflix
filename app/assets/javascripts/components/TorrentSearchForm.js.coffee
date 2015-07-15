component 'TorrentSearchForm',

  onSubmit: (event) ->
    event.preventDefault()
    value = @refs.input.getDOMNode().value
    Location.set("/search?s=#{encodeURIComponent(value)}")
  
  render: ->
    {div, Form} = DOM
    Form(
      className: 'TorrentSearchForm'
      onSubmit: @onSubmit
      DOM.input
        ref: 'input'
    )
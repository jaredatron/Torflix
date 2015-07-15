component 'TorrentSearchForm',

  getInitialState: ->
    value: Location.params.s || ""

  getValue: ->
    @refs.input.getDOMNode().value

  onSubmit: (event) ->
    event.preventDefault()
    Location.set("/search?s=#{encodeURIComponent(@getValue())}")

  onChange: (event) ->
    @setState value: @getValue()

  componentDidMount: ->
    Location.on('change', @setValueFromParams)
  
  componentWillUnmount: ->
    Location.off('change', @setValueFromParams)

  setValueFromParams: ->
    return unless Location.path == '/search'
    @setState value: (Location.params.s || "")
  
  render: ->
    {div, Form} = DOM
    Form(
      className: 'TorrentSearchForm'
      onSubmit: @onSubmit
      DOM.input
        ref: 'input'
        value: @state.value
        onChange: @onChange
    )
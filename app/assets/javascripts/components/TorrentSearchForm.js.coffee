component 'TorrentSearchForm',

  getInitialState: ->
    value: Location.params.s || ""

  getValue: ->
    @refs.input.getDOMNode().value

  valueIsBlank: ->
    @state.value.match(/^\s*$/)

  valueIsMagnetLink: ->
    @state.value.match(/^magnet:/)

  clear: ->
    @setState value: ''

  onSubmit: (event) ->
    event.preventDefault()
    if @valueIsMagnetLink()
      App.putio.transfers.add @state.value
      Location.set Location.for('/autoplay', link: @state.value)
      @clear()
    else
      Location.set Location.for('/search', s: @getValue())


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
    Form
      className: 'TorrentSearchForm'
      onSubmit: @onSubmit
      DOM.input
        ref: 'input'
        value: @state.value
        onChange: @onChange

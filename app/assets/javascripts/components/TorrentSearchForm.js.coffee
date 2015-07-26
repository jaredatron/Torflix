component 'TorrentSearchForm',

  getInitialState: ->
    value: valueFromParams()

  setValueFromParams: ->
    @setState value: valueFromParams()

  clear: ->
    @setState value: ''

  onSearch: (query) ->
    if isMagnetLink(query)
      App.putio.transfers.add query
      Location.set Location.for('/autoplay', link: query)
      @clear()
    else
      Location.set Location.for('/search', s: query)

  onChange: (value) ->
    @setState value: value

  componentDidMount: ->
    Location.on('change', @setValueFromParams)

  componentWillUnmount: ->
    Location.off('change', @setValueFromParams)

  render: ->
    DOM.SearchForm
      className: 'TorrentSearchForm'

      onSearch:  @onSearch
      value:     @state.value
      onChange:  @onChange


valueFromParams = ->
  if Location.path == '/search'
    Location.params.s || ""
  else
    ""


isMagnetLink = (string) ->
  string.match(/^magnet:/)

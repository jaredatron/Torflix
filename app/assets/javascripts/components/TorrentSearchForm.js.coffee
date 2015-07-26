component 'TorrentSearchForm',

  getInitialState: ->
    query: valueFromParams()

  componentDidMount: ->
    Location.on('change', @updateQueryFromParams)

  componentWillUnmount: ->
    Location.off('change', @updateQueryFromParams)

  updateQueryFromParams: ->
    @setState query: valueFromParams()


  onSearch: (query) ->
    if isMagnetLink(query)
      App.putio.transfers.add query
      Location.set Location.for('/autoplay', link: query)
    else
      Location.set Location.for('/search', s: query)

  render: ->
    console.log('TorrentSearchForm', @state)
    DOM.SearchForm
      key:            "query-#{@state.query}"
      collectionName: 'torrents'
      className:      'TorrentSearchForm'
      defaultValue:    @state.query
      onSearch:        @onSearch


valueFromParams = ->
  if Location.path == '/search'
    Location.params.s || ""
  else
    ""


isMagnetLink = (string) ->
  string.match(/^magnet:/)

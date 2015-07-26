component 'ShowSearchForm',

  getInitialState: ->
    query: valueFromParams()

  componentDidMount: ->
    Location.on('change', @updateQueryFromParams)

  componentWillUnmount: ->
    Location.off('change', @updateQueryFromParams)

  updateQueryFromParams: ->
    @setState query: valueFromParams()


  onSearch: (query) ->
    Location.set Location.for('/search/shows', s: query)

  render: ->
    console.log('ShowSearchForm', @state)
    DOM.SearchForm
      key:         "query-#{@state.query}"
      className:   'ShowSearchForm'
      defaultValue: @state.query
      onSearch:     @onSearch


valueFromParams = ->
  if Location.path == '/search/shows'
    Location.params.s || ""
  else
    ""


isMagnetLink = (string) ->
  string.match(/^magnet:/)

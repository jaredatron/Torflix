component 'ShowSearchForm',

  onSearch: (query) ->
    Location.set Location.for('/shows/search', s: query)

  render: ->
    DOM.SearchForm
      collectionName: 'shows'
      className:      'ShowSearchForm'
      onSearch:        @onSearch
      autofocus:       @props.autofocus


component 'FilesSearchForm',

  onSearch: (query) ->
    Location.set Location.for('/files/search', s: query)

  render: ->
    DOM.SearchForm
      collectionName: 'shows'
      className:      'FilesSearchForm'
      onSearch:        @onSearch
      autofocus:       @props.autofocus


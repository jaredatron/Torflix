component 'TorrentSearchForm',

  onSearch: (query) ->
    if isMagnetLink(query)
      App.putio.transfers.add query
      Location.set Location.for('/autoplay', link: query)
    else
      Location.set Location.for('/search', s: query)

  render: ->
    DOM.SearchForm
      defaultValue:    @props.defaultValue
      collectionName: 'torrents'
      onSearch:        @onSearch

isMagnetLink = (string) ->
  string.match(/^magnet:/)

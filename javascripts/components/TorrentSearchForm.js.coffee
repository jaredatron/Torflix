component 'TorrentSearchForm',

  onSearch: (query) ->
    if isMagnetLink(query)
      App.putio.transfers.add query
      Location.set Location.for('/autoplay', link: query)
    else
      Location.set Location.for('/search', s: query)

  render: ->
    DOM.SearchForm
      collectionName: 'torrents'
      className:      'TorrentSearchForm'
      onSearch:        @onSearch

isMagnetLink = (string) ->
  string.match(/^magnet:/)

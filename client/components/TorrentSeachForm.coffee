component = require 'reactatron/component'
SearchForm = require './SearchForm'

module.exports = component 'TorrentSeachForm',

  onSearch: (query) ->
    if isMagnetLink(query)
      @app.pub 'download torrent', query
      @app.setLocation @app.locationFor('/autoplay', link: query)
    else
      @app.setLocation @app.locationFor('/search', s: query)

  render: ->
    SearchForm
      style:           @props.style
      defaultValue:    @props.defaultValue
      collectionName: 'torrents'
      onSearch:        @onSearch



isMagnetLink = (value) ->
  value.match(/^magnet:/)

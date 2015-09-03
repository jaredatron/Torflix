component = require 'reactatron/component'
SearchForm = require './SearchForm'

module.exports = component 'TorrentSeachForm',

  onSearch: (query) ->
    if isMagnetLink(query)
      @app.pub 'download torrent', query
      @app.setLocation path: '/autoplay', params: {link: query}
    else
      path = "/search/#{encode(query)}" if query
      @app.setLocation path: path

  render: ->
    SearchForm
      style:           @props.style
      defaultValue:    @props.defaultValue
      collectionName: 'torrents'
      onSearch:        @onSearch



isMagnetLink = (value) ->
  value.match(/^magnet:/)


encode = (part) ->
  encodeURIComponent(part).replace('%20','+')

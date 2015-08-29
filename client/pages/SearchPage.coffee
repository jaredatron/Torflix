component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Layout = require '../components/Layout'
TorrentSeachForm = require '../components/TorrentSeachForm'
TorrentSearchResults = require '../components/TorrentSearchResults'

module.exports = component 'SearchPage',

  render: ->
    query = @props.s || ''
    console.log('query', query)
    Layout null,
      Rows style: width: '100%',
        TorrentSeachForm
          style:
            margin: '1em'
          defaultValue: query
        TorrentSearchResults query: query

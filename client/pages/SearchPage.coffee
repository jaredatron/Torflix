component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Layout = require '../components/Layout'
TorrentSeachForm = require '../components/TorrentSeachForm'
TorrentSearchResults = require '../components/TorrentSearchResults'

module.exports = component 'SearchPage',

  componentDidMount: ->
    @getDOMNode().querySelector('input[type=text]').focus()

  render: ->
    query = @props.query

    if query?
      results = TorrentSearchResults query: query

    Layout null,
      Rows style: {width: '100%', overflowY: 'scroll'},
        TorrentSeachForm
          style: margin: '1em'
          defaultValue: query
        results





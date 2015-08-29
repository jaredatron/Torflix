component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Box = require 'reactatron/Box'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'
TorrentSeachForm = require '../components/TorrentSeachForm'

module.exports = component 'TransfersPage',

  dataBindings: ->
    transfers: 'transfers'
    loading:   'transfers/loading'

  componentDidMount: ->
    if !@state.transfers
      @app.pub 'reload transfers'

  render: ->
    Layout null, 'loading...' unless @state.transfers?

    Layout null,
      Rows style: width: '100%',
        TorrentSeachForm
          style:
            margin: '0.5em'

        TransfersList transfers: @state.transfers

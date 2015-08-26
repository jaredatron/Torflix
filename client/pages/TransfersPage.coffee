component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Box = require 'reactatron/Box'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'TransfersPage',

  componentDidMount: ->
    @app.pub 'reload transfers'

  render: ->
    transfers = @get('transfers')

    Layout null,
      TransfersList
        width: '100%'
        transfers: transfers

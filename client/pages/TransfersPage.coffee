component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'TransfersPage',

  # getDataBindings: ->
  #   ['transfers']

  componentDidMount: ->
    @app.pub 'reload transfers'

  render: ->
    transfers = @get('transfers')

    Layout null,
      Rows grow: 1, overflowY: 'auto',
        Block {}, 'TRANSFERS PAGE'
        # Block {}, 'transfers:', JSON.stringify(transfers)
        TransfersList transfers: transfers
        # TransfersList grow: 1, transfers: transfers

        # div null, 'TRANSFERS PAGE'
        # # div null, 'path:',   JSON.stringify(@props.path)
        # # div null, 'params:', JSON.stringify(@props.params)
        # # div null, 'transfers:', JSON.stringify(@data.transfers)
        # TransfersList
        #   transfers: @data.transfers



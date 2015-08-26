component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Box = require 'reactatron/Box'
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
      TransfersList
        width: '100%'
        transfers: transfers



# Scrollbox = Box.extendStyledComponent 'Scrollbox',
#   height: '100%'
#   width: '100%'
#   overflowY: 'auto'

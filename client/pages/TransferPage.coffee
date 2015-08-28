component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Box = require 'reactatron/Box'
Block = require 'reactatron/Block'
Text = require 'reactatron/Text'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'TransferPage',

  componentDidMount: ->
    if !@getTransfer()
      @app.pub 'load transfer', @getTransferId()

  getTransferId: ->
    @get('params').transfer_id

  getTransfer: ->
    @get("transfers/#{@getTransferId()}")

  render: ->
    params =
    transfer = @getTransfer()

    Layout {},
      Rows style:{padding:'1em'},
        Block {}, Text({},transfer.name)

        Object.keys(transfer).map (key, index) ->
          value = JSON.stringify(transfer[key])
          Block key: index, "#{key}: #{value}"

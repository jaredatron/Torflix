component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Box = require 'reactatron/Box'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'TransfersPage',

  dataBindings: ->
    transfers: 'transfers'
    loading:   'transfers/loading'

  componentDidMount: ->
    if !@state.transfers
      @app.pub 'reload transfers'

  render: ->
    if @state.transfers
      return Layout null,
        TransfersList
          width: '100%'
          transfers: @state.transfers

    Layout null, 'loading...'

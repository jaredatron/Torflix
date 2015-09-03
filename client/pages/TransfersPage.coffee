component = require 'reactatron/component'
Box       = require 'reactatron/Box'
Rows      = require 'reactatron/Rows'
Columns   = require 'reactatron/Columns'
Space     = require 'reactatron/Space'
Block     = require 'reactatron/Block'

Layout           = require '../components/Layout'
TransfersList    = require '../components/TransfersList'
SearchForm       = require '../components/SearchForm'
Button           = require '../components/Button'


module.exports = component 'TransfersPage',

  dataBindings: ->
    transfers: 'transfers'
    loading:   'transfers/loading'

  getInitialState: ->
    filter: ''

  setFilter: (filter) ->
    @setState filter: filter

  componentDidMount: ->
    @app.pub 'start polling for transfers'
    @reloadTransfers() if !@state.transfers

  componentWillUnmount: ->
    @app.pub 'stop polling for transfers'

  reloadTransfers: ->
    @setState transfers: null
    @app.pub 'reload transfers'

  render: ->
    transfersList = if @state.transfers?
      transfers = filter(@state.transfers, @state.filter)
      transfersList = TransfersList transfers: transfers
    else
      LoadingBox {}, 'Loading...'

    Layout null,
      Rows style: {overflowY: 'scroll'},
        Columns style: {margin: '0.5em'},
          FilterForm
            onChange: @setFilter
            style:
              flexGrow: 1
              flexShrink: 1
          Space(2)
          Button onClick: @reloadTransfers, tabIndex: -1, 'reload'
        transfersList


LoadingBox = Box.withStyle 'LoadingBox',
  textAlign: 'center'
  fontSize: '200%'
  padding: '1em'


FilterForm = component 'FilterForm',

  render: ->
    SearchForm
      ref: 'form'
      style:           @props.style
      defaultValue:    @props.defaultValue
      collectionName: 'transfers'
      onChange:        @props.onChange



filter = (transfers, filter) ->
  return transfers if !filter? || filter == ''
  filter = filter.toLowerCase()
  transfers.filter (transfer) ->
    transfer.name.toLowerCase().includes(filter)

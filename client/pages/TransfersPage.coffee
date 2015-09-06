slice = require 'shouldhave/slice'

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
    @getDOMNode().querySelector('input[type=text]').focus()
    @app.pub 'start polling for transfers'
    @reloadTransfers() if !@state.transfers

  componentWillUnmount: ->
    @app.pub 'stop polling for transfers'

  reloadTransfers: ->
    @setState transfers: null
    @app.pub 'reload transfers'

  getFocusableElements: ->
    slice(@getDOMNode().querySelectorAll('.transfers-page-filter-form input, .transfer-list-member-main-link'))

  onKeyDown: (event) ->
    switch event.keyCode
      when 38 # up
        event.preventDefault()
        elements = @getFocusableElements()
        index = elements.indexOf(event.target) - 1
        index = 0 if index < 0
        elements[index]?.focus()
      when 40 # down
        event.preventDefault()
        elements = @getFocusableElements()
        index = elements.indexOf(event.target) + 1
        index = 0 if index >= elements.size
        elements[index]?.focus()
      when 191 # /
        event.preventDefault()
        @getFocusableElements()[0].focus()


  render: ->
    transfersList = if @state.transfers?
      transfers = filter(@state.transfers, @state.filter)
      transfersList = TransfersList transfers: transfers
    else
      LoadingBox {}, 'Loading...'

    Layout null,
      Rows style: {overflowY: 'scroll'}, onKeyDown: @onKeyDown,
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
      className:      'transfers-page-filter-form'



filter = (transfers, filter) ->
  return transfers if !filter? || filter == ''
  filter = filter.toLowerCase()
  transfers.filter (transfer) ->
    transfer.name.toLowerCase().includes(filter)

React     = require 'react'
component = require '../component'

{a, div, table, thead, tbody, tr, td, th} = React.DOM





module.exports = component 'TransfersList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    error: null
    transfers: @context.putio.transfers.toArray()

  transfersChanged: ->
    console.log('transfersChanged')
    setTimeout =>
      @setState transfers: @context.putio.transfers.toArray()

  componentDidMount: ->
    @context.putio.transfers.on('change', @transfersChanged)
    @context.putio.transfers.startPolling()
    # .catch (error) =>
    #   @setState error: error

  componentWillUnmount: ->
    @context.putio.transfers.off('change', @transfersChanged)

  deleteTranfer: (transfer_id) ->
    (event) =>
      event.preventDefault()
      @context.putio.transfers.delete(transfer_id).catch (error) =>
        @setState error: error

  render: ->
    div
      className: 'TransfersList'
      @renderContent()

  renderContent: ->
    switch
      when @state.error
        div(null, "ERROR: #{@state.error}")
      when @state.transfers
        Table(transfers: @state.transfers, deleteTranfer: @deleteTranfer)
      else
        div(null, 'Loading…')


Table = component 'TransfersListTable',


  render: ->
    div className: 'transfers',
      div className: 'header',
        div className: 'delete',     ''
        div className: 'status',     'Status'
        div className: 'name',       'Name'
        div className: 'created_at', 'Created At'
      @props.transfers.map (transfer) =>
        div key: transfer.id, className: 'transfer',
          div className: 'delete',     a(href:'', onClick: @props.deleteTranfer(transfer.id), 'X')
          div className: 'status',     transfer.status
          div className: 'name',       transfer.name
          div className: 'created_at', transfer.created_at



React     = require 'react'
component = require '../component'

{div, table, thead, tbody, tr, td, th} = React.DOM


module.exports = component 'TransfersList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    error: null
    transfers: null

  componentDidMount: ->
    @context.putio.transfers.list()
      .then (response) =>
        @setState transfers: response.transfers
      .catch (error) =>
        @setState error: error

  render: ->
    console.log('REDERING', @state)
    div
      className: 'TransfersList'
      @renderContent()

  renderContent: ->
    switch
      when @state.error
        div(null, "ERROR: #{@state.error}")
      when @state.transfers
        console.dir @state.transfers[0]
        Table(transfers: @state.transfers)
      else
        div(null, 'Loading…')


Table = component 'TransfersListTable',
  render: ->
    rows = @props.transfers.map (transfer) ->
      tr {key: transfer.id, className: 'transfer'},
        td {className: 'name'},
          transfer.name
        td {className: 'created_at'},
          transfer.created_at
        td {className: 'status'},
          transfer.status

    table {className: 'transfers'},
      thead {},
        tr {},
          th {}, 'Status'
          th {}, 'Name'
          th {}, 'Created At'
      tbody {}, rows

React     = require 'react'
component = require '../component'

{div} = React.DOM


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
    rows = @props.transfers.map (transfer, index) ->
      div
        className: 'transfer'
        div
          className: 'name'
          transfer.name
        div
          className: 'created_at'
          transfer.created_at
        div
          className: 'status'
          transfer.status

    div
      className: 'transfers'
      rows

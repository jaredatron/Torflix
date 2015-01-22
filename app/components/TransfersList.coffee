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
    switch
      when @state.error
        div(null, "ERROR: #{@state.error}")
      when @state.transfers
        transfers = @state.transfers.map (transfer, index) ->
          div(null, transfer.name)
        div(null, transfers)
      else
        div(null, 'Loading…')

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
    'hello there people'
    # @context.putio.transfers.list()
    #   .then (response) =>
    #     @setState transfers: response.transfers
    #   .catch (error) =>
    #     @setState error: error

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
        transfers = @state.transfers.map (transfer, index) ->
          div
            className: 'transfers'
            div
              className: 'name'
              transfer.name
            div
              className: 'created at'
              transfer.created_at
            div
              className: 'status'
              transfer.status

        div(null, transfers)
      else
        div(null, 'Loading…')

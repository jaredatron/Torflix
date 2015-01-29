React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
FileList   = require './FileList'
Glyphicon  = require 'react-bootstrap/Glyphicon'

{div, span, a} = React.DOM

SORT = (a, b) ->
  a = Date.parse(a.created_at)
  b = Date.parse(b.created_at)
  return -1 if a > b
  return  1 if a < b
  return  0 if a == b

module.exports = component 'TransfersList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    transfers: @context.putio.transfers.toArray()

  transfersChanged: ->
    setTimeout =>
      @setState transfers: @context.putio.transfers.toArray()

  componentDidMount: ->
    @context.putio.transfers.on('change', @transfersChanged)
    @context.putio.transfers.startPolling()

  componentWillUnmount: ->
    @context.putio.transfers.removeListener('change', @transfersChanged)
    @context.putio.transfers.stopPolling()

  transfers: ->
    @state.transfers.sort(SORT)

  render: ->
    div
      className: 'TransfersList'
      @transfers().map (transfer) ->
        Transfer(key: transfer.id, transfer: transfer)

Transfer = component 'TransfersList-Transfer',

  PropTypes:
    transfer: React.PropTypes.object.isRequired

  getInitialState: ->
    expanded: false

  toggle: ->
    @setState expanded: !@state.expanded

  completed: ->
    @props.transfer.status == "COMPLETED"

  render: ->
    transfer = @props.transfer
    div className: 'TransfersList-Transfer', 'data-status': transfer.status,
      @toggleLink(
        @statusIcon()
        span className: 'TransfersList-Transfer-name', transfer.name
      )
      DeleteLink transfer_id: transfer.id
      @files()

  toggleLink: (children...) ->
    if @completed()
      ActionLink(onClick: @toggle, children...)
    else
      div(null, children...)

  percentDone: ->
    div
      className: 'TransfersList-Transfer-percentDone'
      style: {width: "#{@props.transfer.percent_done}%"}

  statusIcon: ->
    glyph = switch @props.transfer.status
      when 'IN_QUEUE'    then 'pause'
      when 'DOWNLOADING' then 'download-alt'
      when 'COMPLETED'   then 'ok'

    Glyphicon glyph: glyph, className: 'TransfersList-Transfer-statusIcon'

  files: ->
    if @completed() && @state.expanded
      FileList file_id: @props.transfer.file_id


DeleteLink = component 'TransfersList-DeleteLink',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  onClick: ->
    @context.putio.transfers.delete(@props.transfer_id)

  render: ->
    ActionLink
      onClick: @onClick
      className: 'TransfersList-DeleteLink'
      Glyphicon glyph: 'remove'


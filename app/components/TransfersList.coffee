React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
FileList   = require './FileList'
Glyphicon  = require 'react-bootstrap/Glyphicon'
DeleteLink = require './DeleteLink'
FileSize   = require './FileSize'

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
    @props.transfer.status == "COMPLETED" ||
    @props.transfer.status == "SEEDING"

  toggleLink: (props, children...) ->
    if @completed()
      props.onClick = @toggle
      ActionLink(props, children...)
    else
      div(props, children...)

  percentDone: ->
    div
      className: 'TransfersList-Transfer-percentDone'
      style: {width: "#{@props.transfer.percent_done}%"}

  statusIcon: ->
    glyph = switch @props.transfer.status
      when 'IN_QUEUE'    then 'pause'
      when 'DOWNLOADING' then 'download-alt'
      when 'COMPLETING'  then 'wrench'
      when 'SEEDING'     then 'open'
      when 'COMPLETED'   then 'ok'
      else
        console.log('UNKNOWN transfer status', @props.transfer.status)
        'question-sign'

    Glyphicon glyph: glyph, className: 'TransfersList-Transfer-statusIcon'

  files: ->
    if @completed() && @state.expanded
      FileList file_id: @props.transfer.file_id

  render: ->
    transfer = @props.transfer

    transfer.estimated_time
    transfer.percent_done

    div
      className: 'TransfersList-Transfer',
      'data-status': transfer.status,
      style: percentDoneGradientSyle(transfer.percent_done),

      div className: 'flex-row',
        @statusIcon()
        @toggleLink(className: 'TransfersList-Transfer-name', transfer.name),
        div(className: 'subtle-text', transfer.status_message),
        div(className: 'flex-spacer'),
        FileSize(size: transfer.size),
        DeleteTransferLink transfer: transfer
      @files()


GREEN = 'rgba(41,154,11, 0.5)'
TRANSPARENT = 'rgba(0, 0, 0, 0)'
percentDoneGradientSyle = (percent_done) ->
  if percent_done < 100
    {
      background: "linear-gradient(to right, #{GREEN} 0%, #{GREEN} #{percent_done}%, #{TRANSPARENT} #{percent_done}%, #{TRANSPARENT} 100%);"
    }
  else
    {}

DeleteTransferLink = component 'TransfersList-DeleteTransferLink',

  propTypes:
    transfer: React.PropTypes.object.isRequired

  contextTypes:
    putio: React.PropTypes.any.isRequired

  onDelete: ->
    @context.putio.transfers.delete(@props.transfer.id)

  render: ->
    DeleteLink
      className: 'TransfersList-DeleteTransferLink'
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.transfer.name}?"

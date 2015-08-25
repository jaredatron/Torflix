Putio = require '../Putio'
component = require 'reactatron/component'
{div, h1, button} = require 'reactatron/DOM'
ColumnContainer = require './ColumnContainer'
RowContainer = require './RowContainer'

module.exports = component 'TransfersList',

  propTypes:
    transfers: component.PropTypes.any

  render: ->
    transfers = @props.transfers.map (transfer) ->
      Transfer(transfer)
    RowContainer null, transfers
    #


Transfer = component 'TransfersList.Transfer',

  delete: ->
    @app.pub 'delete transfer', id: @props.id

  render: ->
    ColumnContainer null,
      StatusColumn status: @props.status
      NameColumn name: @props.name
      DeleteTransferButton onClick: @delete


StatusColumn = (props={}) ->
  props.style = {
    marginRight: '1em'
  }
  div(props, props.status)

NameColumn = (props={}) ->
  props.style = {}
  div(props, props.name)

# DeleteColumn = (props={}) ->
#   props.style = {}
#   div(props, props.name)

DeleteTransferButton = (props) ->
  button(props, 'X')
# StringInput = require './StringInput'
# ActionLink = require './ActionLink'
# TransfersStatusIcon = require './TransfersStatusIcon'
# TransferFile = require './TransferFile'
# DeleteLink = require './DeleteLink'

# SORT = (a, b) ->
#   a = Date.parse(a.created_at)
#   b = Date.parse(b.created_at)
#   return -1 if a > b
#   return  1 if a < b
#   return  0 if a == b

# module.exports = component 'TransfersList',

#   getInitialState: ->
#     filter: @app.get('location').params.f || ''
#     # transfers: App.putio.transfers.toArray()

#   # filterChange: ->
#   #   @setState filter: @context.params.f || ''

#   setFilter: ->
#     filter = @refs.filter.getValue()
#     filter = undefined if filter == ''
#     @app().updateParams({f: filter}, true)

#   transfersChanged: ->
#     setTimeout =>
#       @setState transfers: App.putio.transfers.toArray()

#   componentDidMount: ->
#     # @context.on('change', @filterChange)
#     App.putio.transfers.on('change', @transfersChanged)
#     App.putio.transfers.startPolling()

#   componentWillUnmount: ->
#     # @context.off('change', @filterChange)
#     App.putio.transfers.removeListener('change', @transfersChanged)
#     App.putio.transfers.stopPolling()

#   renderTransfers: ->
#     if @state.transfers.length > 0
#       @state.transfers.
#         sort(SORT).
#         filter(filterBy(@state.filter)).
#         map(transferToComponent)
#     else
#       div(null, 'loading...')


#   render: ->
#     div
#       className: 'TransfersList'
#       div
#         className: 'flex-row flex-justify-content-end'
#         StringInput
#           ref: 'filter'
#           value: @state.filter
#           onChange: @setFilter
#           glyph: 'filter'
#       @renderTransfers()

# transferToComponent = (transfer) ->
#   Transfer(key: transfer.id, transfer: transfer)

# filterBy = (filter) ->
#   filter = filter.toLowerCase()
#   return (transfer) ->
#     name = transfer.name.toLowerCase()
#     name.includes(filter)


# Transfer = component 'TransfersList-Transfer',

#   PropTypes:
#     transfer: component.PropTypes.instanceOf(Putio.Transfer).isRequired

#   sessionKey: ->
#     "TransfersList-Transfer-#{@props.transfer.id}-expanded"

#   reload: ->
#     @forceUpdate()

#   componentDidMount: ->
#     @props.transfer.on('change', @transferChanged)
#     App.session.on("change:#{@sessionKey()}", @reload)

#   componentWillUnmount: ->
#     @props.transfer.removeListener('change', @transferChanged)
#     App.session.removeListener("change:#{@sessionKey()}", @reload)

#   transferChanged: ->
#     @forceUpdate()

#   expanded: ->
#     App.session(@sessionKey()) || false

#   toggle: ->
#     App.session(@sessionKey(), !@expanded())

#   completed: ->
#     @props.transfer.status == "COMPLETED" ||
#     @props.transfer.status == "SEEDING"

#   toggleLink: (props, children...) ->
#     if @completed()
#       props.onClick = @toggle
#       ActionLink(props, children...)
#     else
#       div(props, children...)

#   percentDone: ->
#     div
#       className: 'TransfersList-Transfer-percentDone'
#       style: {width: "#{@props.transfer.percent_done}%"}

#   statusIcon: ->
#     TransfersStatusIcon status: @props.transfer.status

#   files: ->
#     if @completed() && @expanded()
#       TransferFile file_id: @props.transfer.file_id

#   render: ->
#     transfer = @props.transfer

#     {div, FileSize} = DOM

#     className = Classnames('TransfersList-Transfer',
#       'TransfersList-Transfer-complete':    transfer.isComplete
#       'TransfersList-Transfer-deleting':    transfer.isDeleting
#       'TransfersList-Transfer-deleted':     transfer.isDeleted
#       'TransfersList-Transfer-downloading': transfer.isDownloading
#     )

#     div
#       className: className
#       'data-status': transfer.status,
#       style: percentDoneGradientSyle(transfer),

#       div className: 'flex-row',
#         @statusIcon()
#         @toggleLink(className: 'TransfersList-Transfer-name', transfer.name),
#         div(className: 'subtle-text', transfer.status_message),
#         div(className: 'flex-spacer'),
#         FileSize(size: transfer.size),
#         DeleteTransferLink transfer: transfer
#       @files()


# GREEN = 'rgba(41,154,11, 0.5)'
# TRANSPARENT = 'rgba(0, 0, 0, 0)'
# percentDoneGradientSyle = (transfer) ->
#   return unless transfer.status == 'DOWNLOADING'
#   return unless transfer.percent_done < 100
#   percent_done = transfer.percent_done
#   {
#     backgroundImage: "linear-gradient(to right, #{GREEN} 0%, #{GREEN} #{percent_done}%, #{TRANSPARENT} #{percent_done}%, #{TRANSPARENT} 100%)"
#   }

# DeleteTransferLink = component 'TransfersList-DeleteTransferLink',

#   propTypes:
#     transfer: component.PropTypes.instanceOf(Putio.Transfer).isRequired

#   onDelete: ->
#     @props.transfer.delete()
#     # App.putio.transfers.delete(@props.transfer.id)

#   render: ->
#     DeleteLink
#       className: 'TransfersList-DeleteTransferLink'
#       onDelete: @onDelete
#       question: =>
#         "Are you sure you want to delete #{@props.transfer.name}?"

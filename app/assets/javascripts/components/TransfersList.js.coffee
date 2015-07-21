SORT = (a, b) ->
  a = Date.parse(a.created_at)
  b = Date.parse(b.created_at)
  return -1 if a > b
  return  1 if a < b
  return  0 if a == b

component 'TransfersList',

  getInitialState: ->
    transfers: App.putio.transfers.toArray()

  transfersChanged: ->
    setTimeout =>
      @setState transfers: App.putio.transfers.toArray()

  componentDidMount: ->
    App.putio.transfers.on('change', @transfersChanged)
    App.putio.transfers.startPolling()
    App.putio.transfers.load()

  componentWillUnmount: ->
    App.putio.transfers.removeListener('change', @transfersChanged)
    App.putio.transfers.stopPolling()

  renderTransfers: ->
    if @state.transfers.length > 0
      @state.transfers.sort(SORT).map (transfer) ->
        Transfer(key: transfer.id, transfer: transfer)
    else
      DOM.div(null, 'loading...')


  render: ->
    DOM.div
      className: 'TransfersList'
      @renderTransfers()


Transfer = component
  displayName: 'TransfersList-Transfer',

  PropTypes:
    transfer: React.PropTypes.object.isRequired

  sessionKey: ->
    "TransfersList-Transfer-#{@props.transfer.id}-expanded"

  reload: ->
    @forceUpdate()

  componentDidMount: ->
    App.session.on("change:#{@sessionKey()}", @reload)

  componentWillUnmount: ->
    App.session.removeListener("change:#{@sessionKey()}", @reload)

  expanded: ->
    App.session(@sessionKey()) || false

  toggle: ->
    App.session(@sessionKey(), !@expanded())

  completed: ->
    @props.transfer.status == "COMPLETED" ||
    @props.transfer.status == "SEEDING"

  toggleLink: (props, children...) ->
    if @completed()
      props.onClick = @toggle
      DOM.ActionLink(props, children...)
    else
      DOM.div(props, children...)

  percentDone: ->
    DOM.div
      className: 'TransfersList-Transfer-percentDone'
      style: {width: "#{@props.transfer.percent_done}%"}

  statusIcon: ->
    DOM.TransfersStatusIcon status: @props.transfer.status

  files: ->
    if @completed() && @expanded()
      DOM.TransferFile file_id: @props.transfer.file_id

  render: ->
    transfer = @props.transfer

    {div, FileSize} = DOM

    div
      className: 'TransfersList-Transfer',
      'data-status': transfer.status,
      style: percentDoneGradientSyle(transfer),

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
percentDoneGradientSyle = (transfer) ->
  return unless transfer.status == 'DOWNLOADING'
  return unless transfer.percent_done < 100
  percent_done = transfer.percent_done
  {
    backgroundImage: "linear-gradient(to right, #{GREEN} 0%, #{GREEN} #{percent_done}%, #{TRANSPARENT} #{percent_done}%, #{TRANSPARENT} 100%)"
  }

DeleteTransferLink = component
  displayName: 'TransfersList-DeleteTransferLink',

  propTypes:
    transfer: React.PropTypes.object.isRequired

  onDelete: ->
    App.putio.transfers.delete(@props.transfer.id)

  render: ->
    DOM.DeleteLink
      className: 'TransfersList-DeleteTransferLink'
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.transfer.name}?"

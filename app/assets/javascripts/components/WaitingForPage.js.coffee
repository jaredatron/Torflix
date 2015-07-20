#= require ReactPromptMixin
#= require Show

component 'WaitingForPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    transfers: App.putio.transfers.toArray()
    transfer: null

  transfersChanged: ->
    setTimeout =>
      magnetLink = @context.params.link
      transfers = App.putio.transfers.toArray()
      transfer_id = null
      transfers.forEach (transfer) ->
        transfer_id = transfer.id if (
          transfer.magneturi = magnetLink ||
          transfer.source = magnetLink
        )
      @setState
        transfers: transfers
        transfer_id: transfer_id

  componentDidMount: ->
    App.putio.transfers.on('change', @transfersChanged)
    App.putio.transfers.startPolling()
    App.putio.transfers.load()

  componentWillUnmount: ->
    App.putio.transfers.removeListener('change', @transfersChanged)
    App.putio.transfers.stopPolling()

  render: ->
    DOM.div
      className: 'ShowPage'
      if @state.transfer_id
        PromiseStateMachine
          promise: App.putio.transfers.get(@context.params.show_id)
          loaded: @renderTransfers

  renderTransfer: (transfer) ->
    console.log(transfer)
    DOM.div(null, JSON.stringify(transfer))


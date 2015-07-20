#= require ReactPromptMixin
#= require Show

component 'WaitingForPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    magnet_link = @context.params.link
    transfer_wait_machine: new TransferWaitMachine(magnet_link)

  transfersChanged: ->
    App.putio.transfers.findByMagnetLink(@state.magnet_link).then (transfer) =>
      @setState transfer: transfer

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
      if @state.transfer
        DOM.div(null, JSON.stringify(@state.transfer))
        PromiseStateMachine
          promise: App.putio.files.get(@state.transfer.file_id)
          loaded: @redirectToFile

  redirectToFile: (x) ->
    debugger




# waiting for transfer
# waiting for transfer to finish download
# finding video
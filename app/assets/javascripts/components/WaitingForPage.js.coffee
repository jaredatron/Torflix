#= require ReactPromptMixin
#= require Show

component 'WaitingForPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    magnetLink = @context.params.link
    transferWaitMachine = App.putio.transfers.waitFor(magnetLink)
    window.DEBUG = transferWaitMachine
    transferWaitMachine.on('change', @onTransferWaitMachineChange)
    {
      magnetLink: magnetLink
      transferWaitMachine: transferWaitMachine
      transferWaitMachineState: transferWaitMachine.state
    }

  componentDidMount: ->
    @state.transferWaitMachine.start()

  componentWillUnmount: ->
    @state.transferWaitMachine.abort()

  onTransferWaitMachineChange: (state) ->
    if 'ready' == state
      video_id = @state.transferWaitMachine.videoFile.id
      Location.set("/video/#{video_id}", true)
    @setState transferWaitMachineState: state

  promise: ->
    App.putio.transfers.get(@state.transfer_id).then (transfer) ->
      if transfer.status == 'COMPLETED' || transfer.status == 'SEEDING'
        App.putio.files.get(transfer.file_id)
      else
        transfer

  render: ->
    console.log('WaitingForPage', @state)
    {div, h1} = DOM
    div
      className: 'ShowPage'
      h1(null, @state.transferWaitMachineState)



# waiting for transfer
# waiting for transfer to finish download
# finding video

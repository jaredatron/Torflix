#= require ReactPromptMixin
#= require Show

component 'AutoplayPage',

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
    console.log('AutoplayPage', @state)
    {div, h1} = DOM
    state = @state.transferWaitMachineState
    div
      className: 'AutoplayPage flex-frame'
      h1(null, state)
      @renderProgressBar() if 'downloading' == state

  renderProgressBar: ->
    DOM.progress
      max: 100
      value: @state.transferWaitMachine.transfer.percent_done


# waiting for transfer
# waiting for transfer to finish download
# finding video

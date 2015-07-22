#= require 'eventemitter3'

Putio.TransferWaitMachine = class extends EventEmitter
  constructor: (magnetLink) ->
    @aborted = false
    @state = 'waiting' # waiting | downloading | converting | ready
    @magnetLink = magnetLink
    @transfer = null
    @file = null
    @videoFile = null

  start: ->
    return if @aborted
    @findByMagnetLink()

  abort: ->
    @aborted = true

  triggerChange: ->
    return if @aborted
    @state = @getState()
    @emit('change', @state)

  findByMagnetLink: ->
    return if @aborted
    App.putio.transfers.findByMagnetLink(@magnetLink).then (transfer) =>
      if !transfer
        console.log('transfer not found in local cache')
        @triggerChange()
        @loadTransfers()
      else
        @transfer = transfer
        @waitForTorrentToDownload()
        @triggerChange()
        @emit('change', @state)

    this

  loadTransfers: ->
    return if @aborted
    App.putio.transfers.load().then(@findByMagnetLink.bind(this))

  waitForTorrentToDownload: ->
    return if @aborted
    if @transfer.file_id?
      @loadFile()
      @triggerChange()
    else
      App.putio.transfers.get(@transfer.id, true).then (transfer) =>
        @transfer = transfer
        setTimeout((=> @waitForTorrentToDownload()), 1000)
        @triggerChange()

  loadFile: ->
    return if @aborted
    @transfer.file().then (file) =>
      if file == null
        debugger

      if file.isVideo
        @videoFile = file

      if file.isDirectory
        @directory = file
        App.putio.files.list(@directory.id).then (files) =>
          videos = files.filter (file) -> file.isVideo
          @videoFile = videos[0]
          @triggerChange()

      @triggerChange()

  getState: ->
    if @videoFile?
      return 'ready'
    if @directory?
      return 'searching'
    if @transfer?
      return 'loading files' if @transfer.isComplete
      return 'downloading' if !@transfer.isComplete
    return 'waiting'






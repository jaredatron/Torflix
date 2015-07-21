#= require 'eventemitter3'

Putio.Transfers = class Transfers extends EventEmitter

  constructor: (putio) ->
    @putio = putio
    @cache = {}
    @polling = false

  toArray: ->
    Object.keys(@cache).map (key) => @cache[key]

  load: ->
    @putio.get('/transfers/list').then (response) =>
      @cache = {}
      response.transfers.forEach (transfer) =>
        @cache[transfer.id] = new Putio.Transfer(transfer)
      # @cache = response.transfers.map (props) ->
      #   new Transfer(props)
      @emit('change')
      response

  TRANSFER_POLL_DELAY: 1000 * 3

  startPolling: ->
    return this if @polling
    @polling = true

    scheduleLoad = =>
      setTimeout(load, @TRANSFER_POLL_DELAY)

    load = =>
      return if !@polling
      if document.visibilityState == "visible"
        @load().then(scheduleLoad).catch(scheduleLoad)
      else
        scheduleLoad()

    load()
    this

  stopPolling: ->
    @polling = false
    this

  get: (id, ignoreCache=false) ->
    throw Error('id must be a number') if 'number' != typeof id
    return Promise.resolve(@cache[id]) if !ignoreCache && id of @cache
    @putio.get("/transfers/#{id}").then (response) =>
      @cache[id] = new Putio.Transfer(response.transfer)

  add: (url) ->
    @putio.post('/transfers/add', url: url).then (response) =>
      @cache[response.transfer.id] = new Putio.Transfer(response.transfer)
      @putio.account.info.load()
      @emit('change')
      response


  delete: (id) ->
    transfer = @cache[id]

    delete_transfer_promise = @putio.post('/transfers/cancel', transfer_ids: id).then (response) =>
      delete @cache[id]
      @emit('change')
      response

    @putio.account.info.load()

    if transfer? && transfer.file_id
      delete_file_promise = @putio.files.delete(transfer.file_id)
      Promise.all([delete_transfer_promise,delete_file_promise])
    else
      delete_transfer_promise


  findByMagnetLink: (magnetLink) ->
    transfer = @toArray().find (transfer) ->
      transfer.source == magnetLink ||
      transfer.magneturi == magnetLink
    Promise.resolve(transfer)

  waitFor: (magnetLink) ->
    new TransferWaitMachine(magnetLink)

class TransferWaitMachine extends EventEmitter
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
    App.putio.files.get(@transfer.file_id).then (file) =>
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






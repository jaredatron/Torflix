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

  get: (id) ->
    debugger if 'number' != typeof id
    throw Error('id must be a number') if 'number' != typeof id
    return Promise.resolve(@cache[id]) if id of @cache
    @putio.get("/transfers/#{id}").then (response) =>
      @cache[id] = new Putio.Transfer(response.transfer)

  add: (url) ->
    @putio.post('/transfers/add', url: url).then (response) =>
      @cache[response.transfer.id] = new Putio.Transfer(response.transfer)
      @putio.account.info.load()
      @emit('change')
      response


  delete: (id) ->
    transfer = @cache.filter((transfer) -> transfer.id == id)[0]

    delete_transfer_promise = @putio.post('/transfers/cancel', transfer_ids: id).then (response) =>
      @cache = transfers.filter((transfer) -> transfer.id != id)
      @emit('change')
      response

    @putio.account.info.load()

    return delete_transfer_promise unless transfer? && transfer.file_id

    delete_file_promise = @putio.files.delete(transfer.file_id)
    Promise.all([delete_transfer_promise,delete_file_promise])


  findByMagnetLink: (magnetLink) ->
    transfer = @toArray().find (transfer) ->
      transfer.source == magnetLink ||
      transfer.magneturi == magnetLink
    Promise.resolve(transfer)

  waitFor: (magnetLink) ->

    new TransferWaitMachine(magnetLink).start();
    # @findByMagnetLink(magnetLink).then (transfer) =>
    #   return transfer if transfer
    #   console.log('transfer not found, reloading')
    #   @load().then =>
    #     @waitFor(magnetLink)




class TransferWaitMachine extends EventEmitter
  constructor: (magnetLink) ->
    @aborted = false
    @state = 'waiting' # waiting | downloading | converting | ready
    @magnetLink = magnetLink
    @transfer = null
    @file = null
    @videoFile = null

  start: ->
    @findByMagnetLink()

  abort: ->
    @aborted = true

  findByMagnetLink: ->
    return if @aborted
    App.putio.transfers.findByMagnetLink(@magnetLink).then (transfer) =>
      if !transfer
        console.log('transfer not found in local cache')
        @state = 'waiting'
        @loadTransfers()
      else
        @transfer = transfer
        @state = @getState()
        @emit('change', @state)

    this

  loadTransfers: ->
    return if @stopped
    App.putio.transfers.load().then(@findByMagnetLink.bind(this))


  getState: ->
    return 'ready'       if @videoFile?
    return 'ready'       if @file? && @file.isVideo
    return 'converting'  if @file? && !@file.isVideo
    return 'downloading' if @transfer && !@transfer.isComplete
    return 'waiting'






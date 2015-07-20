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
        @cache[transfer.id] = transfer
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
      @cache[id] = response.transfer

  add: (url) ->
    @putio.post('/transfers/add', url: url).then (response) =>
      @cache[response.transfer.id] = response.transfer
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


  findByMagnetLink: (magnet_link) ->
    console.log('searching local cache for transfer', @toArray(), magnet_link)
    transfer = @toArray().find (transfer) ->
      transfer.source == magnet_link ||
      transfer.magneturi == magnet_link
    console.log('found:', transfer)
    Promise.resolve(transfer)

  waitFor: (magnet_link) ->

    new TransferWaitMachine(magnet_link).start();
    # @findByMagnetLink(magnet_link).then (transfer) =>
    #   return transfer if transfer
    #   console.log('transfer not found, reloading')
    #   @load().then =>
    #     @waitFor(magnet_link)




class TransferWaitMachine extends EventEmitter
  constructor: (magnet_link) ->
    @magnet_link = magnet_link
    @transfer = null
    @file = null
    @video_file = null

  start: ->
    App.putio.transfers.findByMagnetLink(@magnet_link).then (transfer) =>
      if transfer
        @transfer = transfer
        @emit('change')
      else


  getState: ->
    status: 'waiting' # waiting | downloading | converting | ready






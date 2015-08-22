class Transfers

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
    new Putio.TransferWaitMachine(magnetLink)

module.exports = Transfers

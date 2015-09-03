module.exports = (app) ->

  log = (message) ->
    console.log("%cTransfers: #{message}", 'font-size: 120%; color: red; ')

  get = ( ) -> app.get('transfers')
  set = (t) -> app.set(transfers: t)


  loadAccountInfo = ->
    log("loading account info")
    app.putio.accountInfo().then (accountInfo) ->
      app.set 'accountInfo': accountInfo


  reloadTransfers = ->
    log("reloading transfers")
    app.set "transfers/loading": true

    app.putio.transfers().then (transfers) ->
      app.set
        'transfers/loading': false
        transfers: transfers


  loadTansfer = (event, id) ->
    log("loading transfer #{id}")
    console.log('would load transfer', id)


  deleteTransfer = (event, id) ->
    log("deleting transfer #{id}")

    updateTransfer(id, status: 'DELETING')

    app.putio.deleteTransfer(id).then ->
      removeTransfer(id)



  addTransfer = (event, magnetLink) ->
    log("adding transfer #{magnetLink}")
    app.putio.addTransfer(magnetLink).then (transfer) ->
      transfers = app.get 'transfers'
      transfers.unshift(transfer)
      app.set transfers: transfers


  TRANSFER_POLL_DELAY = 1000 * 5
  pollingForTransfers = false
  startPollingForTransfers = ->
    return if pollingForTransfers
    pollingForTransfers = true
    scheduleLoad = ->
      setTimeout(load, TRANSFER_POLL_DELAY)
    load = =>
      return if !pollingForTransfers
      if document.visibilityState == "visible"
        reloadTransfers().then(scheduleLoad)
      else
        scheduleLoad()

    scheduleLoad()


  stopPollingForTransfers = ->
    pollingForTransfers = false



  app.sub 'load accountInfo', loadAccountInfo
  app.sub 'reload transfers', reloadTransfers
  app.sub 'load transfer',    loadTansfer
  app.sub 'delete transfer',  deleteTransfer
  app.sub 'add transfer',     addTransfer
  app.sub 'start polling for transfers', startPollingForTransfers
  app.sub 'stop polling for transfers',  stopPollingForTransfers



  updateTransfer = (id, props) ->
    transfers = get()
    transfer = findTransfer(transfers, id)
    Object.assign(transfer, props)
    set(transfers)


  withoutId = (id) ->
    (transfer) ->



  withoutTransfer = (transfers, id) ->
    transfers.filter (transfer) ->
      transfer.id != id

  findTransfer = (transfers, id) ->
    transfers.find (transfer) ->
      transfer.id == id


  removeTransfer = (transfers, id) ->
    transfers = get()
    transfers = withoutTransfer(transfers, id)
    set transfers

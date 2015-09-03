module.exports = (app) ->

  log = (message) ->
    console.log("%cTransfers: #{message}", 'font-size: 120%; color: red; ')

  get = -> app.get('transfers')
  set = (transfers) -> app.set('transfers', transfers)


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


  deleteTransfer = (event, info) ->
    return unless info.id?
    log("deleting transfer #{info.id}")



  addTransfer = (event, magnetLink) ->
    log("adding transfer #{magnetLink}")
    app.putio.addTransfer(magnetLink).then (transfer) ->
      transfers = app.get 'transfers'
      transfers.unshift(transfer)
      app.set transfers: transfers




  app.sub 'load accountInfo', loadAccountInfo
  app.sub 'reload transfers', reloadTransfers
  app.sub 'load transfer',    loadTansfer
  app.sub 'delete transfer',  deleteTransfer
  app.sub 'add transfer',     addTransfer




  withoutId = (id) ->
    (transfer) ->



  withoutTransfer = -> (transfers, id) ->
    transfers.filter (transfer) ->
      transfer.id != id

  findTransfer = -> (transfers, id) ->
    transfers.find (transfer) ->
      transfer.id == id


  removeTransfer = (transfers, id) ->

    transfers = get()
    transfers = withoutTransfer(transfers, info.id)
    set transfers

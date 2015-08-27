module.exports = (app) ->

  app.sub 'reload transfers', ->
    app.putio.transfers().then (transfers) ->
      transferIds = app.get('transferIds') || []
      changes = {}
      for id in transferIds
        changes["transfers/#{id}"] = undefined
      transferIds = changes['transferIds'] = []
      transfers.forEach (transfer) ->
        transferIds.push transfer.id
        changes["transfers/#{transfer.id}"] = transfer
      app.set(changes)


  app.sub 'load accountInfo', ->
    app.putio.accountInfo().then (accountInfo) ->
      app.set 'accountInfo': accountInfo

  app.sub 'delete transfer', (event, info) ->
    # app.putio.deleteTransfers().then (transfers) ->
    if info.id
      transferIds = app.get('transferIds') || []
      app.set
        "transfers/#{info.id}": undefined
        "transferIds": transferIds.without(info.id)


EventEmitter = require('events').EventEmitter
assign       = require('object-assign')
qwest        = require('qwest')

ENDPOINT = 'https://api.put.io/v2'

module.exports = (TOKEN) ->

  putio = {}

  url = (path) ->
    "#{ENDPOINT}#{path}?oauth_token=#{TOKEN}"

  putio.get = (path, params) ->
    qwest.get(url(path), params)

  putio.post = (path, params) ->
    qwest.post(url(path), params)




  transfers = []

  putio.transfers = assign({}, EventEmitter.prototype)

  putio.transfers.toArray = ->
    [].concat(transfers) # clone

  putio.transfers.load = ->
    putio.get('/transfers/list').then (response) =>
      transfers = response.transfers
      @emit('change')
      response

  TRANSFER_POLL_DELAY = 1000 * 30
  polling_transfers = false
  putio.transfers.startPolling = ->
    return this if polling_transfers
    polling_transfers = true
    load = ->
      console.log('POLLING TRANSFERS')
      putio.transfers.load().complete ->
        return unless polling_transfers
        setTimeout(load, TRANSFER_POLL_DELAY)
    load()
    this

  putio.transfers.stopPolling = ->
    polling_transfers = false
    this

  putio.transfers.add = (url) ->
    putio.post('/transfers/add', url: url).then (response) =>
      transfers.push response.transfer
      @emit('change')
      response


  putio.transfers.delete = (id) ->
    transfer = transfers.filter((transfer) -> transfer.id == id)[0]

    delete_transfer_promise = putio.post('/transfers/cancel', transfer_ids: id).then (response) =>
      transfers = transfers.filter((transfer) -> transfer.id != id)
      @emit('change')
      response

    return delete_transfer_promise unless transfer? && transfer.file_id

    delete_file_promise = putio.files.delete(transfer.file_id)
    Promise.all([delete_transfer_promise,delete_file_promise])



  files = {}

  putio.files = assign({}, EventEmitter.prototype)

  putio.files.get = (id) ->
    return Promise.resolve(file) if file = files[id]
    putio.get("/files/#{id}").then (response) =>
      file = response.file
      files[file.id] = file
      file

      # https://api.put.io/v2/files/list?parent_id=270984407&oauth_token=VXWAPF8R&__t=1422230397270

  putio.transfers.list = (parent_id) ->
    parent_id ||= 0
    putio.get('/files/list', parent_id: parent_id).then (response) =>
      response.files.each (file) ->
        files[file.id] = file
      response.files

  putio.files.delete = (id) ->
    putio.post('/files/delete', file_ids: id).then (response) =>
      @emit('change')
      response





  return putio






# 4 debugging
global.qwest = qwest

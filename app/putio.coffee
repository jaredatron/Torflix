EventEmitter = require('events').EventEmitter
assign       = require('object-assign')
qwest        = require('qwest')

ENDPOINT = 'https://api.put.io/v2'

module.exports = (TOKEN) ->

  console.warn('CREATING PUTIO')

  putio = {TOKEN: TOKEN}

  url = (path) ->
    "#{ENDPOINT}#{path}?oauth_token=#{TOKEN}"

  putio.get = (path, params) ->
    qwest.get(url(path), params)

  putio.post = (path, params) ->
    qwest.post(url(path), params)




  transfers = []

  global.GET_TRANSFERS = ->
    transfers

  putio.transfers = assign({}, EventEmitter.prototype)

  putio.transfers.toArray = ->
    [].concat(transfers) # clone

  putio.transfers.load = ->
    putio.get('/transfers/list').then (response) =>
      transfers = response.transfers
      @emit('change')
      response

  TRANSFER_POLL_DELAY = 1000 * 3
  polling_transfers = false
  putio.transfers.startPolling = ->
    return this if polling_transfers
    polling_transfers = true
    load = ->
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



  FILES_CACHE = {}
  DIRECTORY_CONTENTS_CACHE = {}

  putio.files = {}

  putio.files.get = (id) ->
    return Promise.resolve(file) if file = FILES_CACHE[id]
    putio.get("/files/#{id}").then (response) =>
      file = response.file
      FILES_CACHE[file.id] = file
      file

      # https://api.put.io/v2/files/list?parent_id=270984407&oauth_token=VXWAPF8R&__t=1422230397270

  putio.files.clearCache = (file_id) ->
    delete FILES_CACHE[file_id]
    delete DIRECTORY_CONTENTS_CACHE[file_id]
    return this

  putio.files.list = (parent_id) ->
    parent_id ||= 0
    return Promise.resolve(files) if files = DIRECTORY_CONTENTS_CACHE[parent_id]
    putio.get('/files/list', parent_id: parent_id).then (response) =>
      files = response.files
      DIRECTORY_CONTENTS_CACHE[parent_id] = files
      files.forEach (file) -> FILES_CACHE[file.id] = file
      files

  putio.files.delete = (id) ->
    putio.post('/files/delete', file_ids: id).then (response) =>
      delete FILES_CACHE[id]
      response


  return putio






# 4 debugging
global.qwest = qwest

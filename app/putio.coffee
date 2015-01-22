EventEmitter = require('events').EventEmitter
assign       = require('object-assign')
qwest        = require('qwest')

ENDPOINT = 'https://api.put.io/v2'

module.exports = (TOKEN) ->

  putio = {}

  url = (path) ->
    "#{ENDPOINT}#{path}?oauth_token=#{TOKEN}"

  putio.get = (path) ->
    qwest.get(url(path))

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



  # files = []

  putio.files = assign({}, EventEmitter.prototype)

  putio.files.delete = (id) ->
    putio.post('/files/delete', file_ids: id).then (response) =>
      @emit('change')
      response





  return putio






# 4 debugging
global.qwest = qwest

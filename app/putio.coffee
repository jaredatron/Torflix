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
    transfers

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


  return putio






# 4 debugging
global.qwest = qwest

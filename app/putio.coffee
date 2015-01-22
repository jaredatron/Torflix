qwest = require 'qwest'


ENDPOINT = 'https://api.put.io/v2'

module.exports = (TOKEN) ->

  putio = {}

  putio.get = (path) ->
    qwest.get("#{ENDPOINT}#{path}?oauth_token=#{TOKEN}")

  putio.transfers = {}

  putio.transfers.list = ->
    putio.get('/transfers/list')

  return putio






# 4 debugging
global.qwest = qwest

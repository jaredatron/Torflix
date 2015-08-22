# EventEmitter = require 'eventemitter3'
# require 'stdlibjs/Object.assign'
# AccountInfo = require './Putio/AccountInfo'
Transfers   = require './Putio/Transfers'
# Files       = require './Putio/Files'
request     = require './request'

class Putio

  constructor: (app) ->
    @app = app
    @transfers = new Transfers(this)

  #   @account = {}
  #   @account.info = new AccountInfo(this)
  #   @transfers    = new Transfers(this)
  #   @files        = new Files(this)

  ENDPOINT: 'https://api.put.io/v2'

  token: ->
    @app.get('put_io_access_token')

  url: (path) ->
    "#{@ENDPOINT}#{path}?oauth_token=#{@token()}"

  get: (path, params) ->
    # console.info('PUTIO GET', path, params)
    @request('get', path, params)

  post: (path, params) ->
    # console.info('PUTIO POST', path, params)
    @request('post', path, params)

  request: (method, path, params) ->
    request(method, @url(path), params)

module.exports = Putio

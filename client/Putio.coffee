request = require './request'

class Putio

  ENDPOINT: 'https://api.put.io/v2'

  constructor: (app) ->
    @app = app
    # @transfers = new Transfers(this)

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

  transfers: ->
    @get('/transfers/list').then (response) =>
      response.transfers

  accountInfo: ->
    @get('/account/info').then (response) =>
      response.info

  #   @account = {}
  #   @account.info = new AccountInfo(this)
  #   @transfers    = new Transfers(this)
  #   @files        = new Files(this)



module.exports = Putio

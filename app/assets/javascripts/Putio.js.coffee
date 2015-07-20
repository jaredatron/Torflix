#= require eventemitter3
#= require Object.assign
#= require qwest
#= require_self
#= require_tree ./Putio

@Putio = class Putio extends EventEmitter

  constructor: (token) ->
    @TOKEN = token
    @account = {}
    @account.info = new Putio.AccountInfo(this)
    @transfers = new Putio.Transfers(this)
    @files = new Putio.Files(this)


  ENDPOINT: 'https://api.put.io/v2'

  TOKEN: null

  url: (path) ->
    "#{@ENDPOINT}#{path}?oauth_token=#{@TOKEN}"

  get: (path, params) ->
    # console.info('PUTIO GET', path, params)
    @request('get', path, params)

  post: (path, params) ->
    # console.info('PUTIO POST', path, params)
    @request('post', path, params)

  request: (method, path, params) ->
    request = $.ajax
      method: method
      url: @url(path)
      data: params
    new Promise (resolve, reject) ->
      request.done (result) ->
        resolve(result)
      request.error (xhr, textStatus, errorThrown) ->
        error = new Error('Putio request failed: '+textStatus+' / '+errorThrown)
        error.xhr = xhr
        reject(error)



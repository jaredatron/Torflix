EventEmitter = require 'eventemitter3'
require 'stdlibjs/Object.assign'
AccountInfo = require './Putio/AccountInfo'
Transfers   = require './Putio/Transfers'
Files       = require './Putio/Files'

@Putio = class Putio extends EventEmitter

  constructor: (token) ->
    @TOKEN = token
    @account = {}
    @account.info = new AccountInfo(this)
    @transfers    = new Transfers(this)
    @files        = new Files(this)

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
    App.request(method, @url(path), params)


require 'stdlibjs/Object.bindAll'

URI = require 'URIjs'
request = require './request'

CLIENT_ID = process.env.PUT_IO_CLIENT_ID
REDIRECT_URI = process.env.PUT_IO_REDIRECT_URI || location.origin

class Putio

  ENDPOINT:     'https://put.io'
  API_ENDPOINT: 'https://api.put.io/v2'

  constructor: ->
    Object.bindAll(this)

  setToken: (token) ->
    @TOKEN = token

  URI: (path, query={}) ->
    query.oauth_token ||= @TOKEN # ???
    URI(@ENDPOINT)
      .query(query)
      .path(path)
      .toString()

  apiURI: (path, query={}) ->
    query.oauth_token ||= @TOKEN
    URI(@API_ENDPOINT)
      .query(query)
      .path(path)
      .toString()


  generateLoginURI: ->
    # "https://api.put.io/v2/oauth2/authenticate?client_id=#{client_id}&response_type=token&redirect_uri=#{redirect_uri}",
    @apiURI '/v2/oauth2/authenticate',
      client_id: CLIENT_ID
      response_type: 'token'
      redirect_uri: REDIRECT_URI

  ###*
  # Make an HTTP request
  #
  # @internal
  # @param {object} element
  ###
  request: (method, path, params) ->
    request(method, @apiURI(path), params)






  accountInfo: ->
    @request('get', '/v2/account/info').then(pluck('info'))


  ###

    Transfers

  ###

  transfers: ->
    @request('get', '/v2/transfers/list').then(pluck('transfers'))


  addTransfer: (magnetLink) ->
    @request('post', '/v2/transfers/add', url: magnetLink).then (response) =>
      response.transfer


  deleteTransfer: (id) ->
    @request('post', '/v2/transfers/cancel', transfer_ids: id)

    # # @putio.account.info.load()

    # if transfer? && transfer.file_id
    #   delete_file_promise = @putio.files.delete(transfer.file_id)
    #   Promise.all([delete_transfer_promise,delete_file_promise])
    # else
    #   delete_transfer_promise


  ###

  files

  ###



  file: (id) ->
    throw new Error('id required') unless id?
    @request('get', "/files/#{id}").then(pluck('file'))

  directoryContents: (id) ->
    amendFile = @amendFile
    @request('get', '/v2/files/list', parent_id: id).then ({parent, files}) ->
      parent.fileIds = files.map(pluckId)
      files.concat([parent]).forEach(amendFile)
      {parent, files}

  #   @account = {}
  #   @account.info = new AccountInfo(this)
  #   @transfers    = new Transfers(this)
  #   @files        = new Files(this)


  IS_VIDEO_REGEXP = /\.(mkv|mp4|avi)$/

  amendFile: (file) ->
    file.isVideo       = IS_VIDEO_REGEXP.test(file.name)
    file.isDirectory   = "application/x-directory" == file.content_type
    file.putioUrl = @URI "/file/#{file.id}"
    if file.isVideo
      file.downloadUrl   = @apiURI "/v2/files/#{file.id}/download"
      file.mp4StreamUrl  = @apiURI "/v2/files/#{file.id}/mp4/stream"
      file.streamUrl     = @apiURI "/v2/files/#{file.id}/stream"
      file.playlistUrl   = @apiURI "/v2/files/#{file.id}/xspf"
      file.chromecastUrl = @URI "/file/#{file.id}/chromecast"
    file



pluck = (key) ->
  (o) -> o[key]
module.exports = Putio


# statics

pluckId = pluck('id')


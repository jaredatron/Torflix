#= require eventemitter3
#= require Object.assign

@Torrent = class Torrent
  constructor: ->

  @ENDPOINT = '/torrents'

  @url = (path) ->
    "#{@ENDPOINT}#{path}"

  @search = (query) ->
    @request('get', '/search', query)

  @get = (id) ->
    @request('get', "/#{id}")

  @add = (id) ->
    @get(id).then (torrent) ->
      App.putio.transfers.add torrent.magnet_link

  @request = (method, path, params) ->
    App.request(method, @url(path), params)

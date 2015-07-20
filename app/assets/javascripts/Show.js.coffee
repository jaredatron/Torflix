#= require 'eventemitter3'
#= require 'Object.assign'

@Show = class Show
  constructor: ->

  @ENDPOINT = '/shows'

  @url = (path) ->
    "#{@ENDPOINT}#{path}"

  @all = ->
    return Promise.resolve(@_all) if @_all?
    @request('get', '/').then (all) =>
      @_all = all

  @search = (query) ->
    @request('get', '/search', query)

  @find = (id) ->
    @request('get', "/#{id}")

  # @add = (id) ->
  #   @get(id).then (torrent) ->
  #     App.putio.transfers.add torrent.magnet_link

  @request = (method, path, params) ->
    App.request(method, @url(path), params)

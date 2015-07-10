#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'qwest'

@Torrent = class Torrent
  constructor: ->

  @ENDPOINT = '/torrents'

  @url = (path) ->
    "#{@ENDPOINT}#{path}"

  @search = (query) ->
    qwest.get(@url('/search'), q: query)
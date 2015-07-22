#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'Object.values'

@Show = class Show
  constructor: (props) ->
    Object.assign(this, props)

  @ENDPOINT = '/shows'

  @request = (method, path, params) ->
    App.request(method, @url(path), params)

  @url = (path) ->
    "#{@ENDPOINT}#{path}"


  @_cache = {}
  @_allCached = false

  @all = ->
    return Promise.resolve(Object.values(@_cache)) if @_allCached
    @request('get', '/').then(cacheShows).then (shows) =>
      @_allCached = true
      shows

  @search = (query) ->
    @request('get', '/search', s: query).then(cacheShows)

  @find = (id) ->
    @request('get', "/#{id}").then(cacheShow).then(cacheShow)


cacheShow = (props) ->
  Show._cache[props.id] = new Show(props)

cacheShows = (shows) ->
  shows.map(cacheShow)


Show.find(12)
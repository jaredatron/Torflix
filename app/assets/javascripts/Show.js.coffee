#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'Object.values'

@Show = class Show
  constructor: (props) ->
    Object.assign(this, props)

  @_cache = {}

  @search = (query) ->
    Thetvdb.search(query)


  @find = (id) ->
    return Promise.resolve(Show._cache[id]) if id in Show._cache
    Thetvdb.getShow(id).then(cacheShow).then(cacheShow)


cacheShow = (props) ->
  Show._cache[props.id] = new Show(props)

cacheShows = (shows) ->
  shows.map(cacheShow)


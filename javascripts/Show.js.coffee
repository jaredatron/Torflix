#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'Object.values'

@Show = class Show
  constructor: (props) ->
    Object.assign(this, props)
    if props.episodes?
      show = this
      @episodes = props.episodes.map (episode) ->
        new Episode(episode, show)

  @_cache = {}

  @search = (query) ->
    Thetvdb.search(query).then(castShows)

  @find = (id) ->
    return Promise.resolve(Show._cache[id]) if id of Show._cache
    Thetvdb.getShow(id).then(castShow).then(cacheShow)


castShow = (show) ->
  new Show(show)

castShows = (shows) ->
  shows.map(castShow)

cacheShow = (show) ->
  Show._cache[show.id] = show

cacheShows = (shows) ->
  shows.map(cacheShow)



Show.Episode = class Episode
  constructor: (props, show) ->
    Object.assign(this, props)
    @show = show


  episodeId: ->
    "S#{zeroPad(@season_number)}E#{zeroPad(@episode_number)}"

  query: ->
    "#{@show.name} #{@episodeId()}"



zeroPad = (number) ->
  number = parseInt(number.toString(), 10).toString()
  number = "0#{number}" if number.length < 2
  number

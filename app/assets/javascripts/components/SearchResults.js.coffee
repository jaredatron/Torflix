component 'SearchResults',

  propTypes:
    promise:      React.PropTypes.object.isRequired
    renderResult: React.PropTypes.func.isRequired


  render: ->
    PromiseStateMachine
      promise: @props.promise
      loaded: @renderLoaded
      # failed: @renderFailed

  renderFailed: (error) ->
    DOM.div(null)

  renderLoaded: (results) ->
    DOM.div
      className: 'SearchResults-results'
      results.map(@renderResult)


  renderResult: (result) ->
    DOM.div
      className: 'SearchResults-result'
      @props.renderResult(result)


#   autoplayEpisode: (episode) ->
#     query = "#{episode.show.name} #{formatEpisodeQuery(episode.season_number, episode.episode_number)}"
#     Location.set Location.for('/search', s: query)

#   render: ->
#     DOM.div
#       className: 'ShowSearchResults'
#       if @props.query?
#         PromiseStateMachine
#           key: "query-#{@props.query}"
#           promise: Show.search(@props.query)
#           loading: ->
#             DOM.div(null, 'loading...')
#           loaded: @renderShows
#           failed: @renderFailed

#   renderShows: (shows) ->
#     console.info('SHOWS:', shows)

#     DOM.div
#       className: ''
#       shows.map(@renderShow)


#   renderShow: (show) ->
#     {div, span, h1, p, ShowArt} = DOM
#     div
#       key: show.id
#       className: ''
#       h1(null, show.name)
#       p(null, show.description)

#   renderEpisodes: (show) ->
#     {div, table, thead, tbody, tr, th} = DOM
#     div
#       className: 'table-responsive'
#       table
#         className: 'table-striped table-bordered table-condensed'
#         thead null,
#           tr null,
#             th null, 'Season'
#             th null, 'Episode'
#             th null, 'Name'
#             th null, 'Description'
#         tbody null,
#           if show.episodes.length == 0
#             tr(null, td(colSpan: 6, 'No episodes found :/'))
#           else
#             show.episodes.map(@renderEpisode)

#   renderEpisode: (episode) ->
#     {tr, td, ActionLink} = DOM


#     query = "#{episode.show.name} #{formatEpisodeQuery(episode.season_number, episode.episode_number)}"
#     href = Location.for('/search', s: query)
#     tr null,
#       td null, episode.season_number
#       td null, episode.seasonal_episode_number
#       td null, ActionLink className: 'link', href: href, episode.name
#       td null, episode.description

#   renderFailed: (error) ->
#     if error.xhr.status == 404
#       DOM.h2(null, "No show found for: #{@props.query}")
#     else
#       DOM.span(null,"Error: #{error}")



# formatEpisodeQuery = (season, episode) ->
#   "S#{zeroPad(season)}E#{zeroPad(episode)}"

# zeroPad = (number) ->
#   number = parseInt(number.toString(), 10).toString()
#   number = "0#{number}" if number.length < 2
#   number

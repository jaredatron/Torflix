component 'ShowSearchResults',

  propTypes:
    query: React.PropTypes.string.isRequired

  autoplayEpisode: (episode) ->
    query = "#{episode.show.name} #{formatEpisodeQuery(episode.season_number, episode.episode_number)}"
    Location.set Location.for('/search', s: query)

  render: ->
    DOM.div
      className: 'ShowSearchResults'
      PromiseStateMachine
        key: "query-#{@props.query}"
        promise: Thetvdb.search(@props.query)
        loading: ->
          DOM.div(null, 'loading...')
        loaded: @renderShow
        failed: @renderFailed

  renderShow: (show) ->
    console.dir(show)
    {div, span, h1, p} = DOM

    div
      className: ''
      h1(null, show.name)
      p(null, show.description)
      @renderEpisodes(show)

  renderEpisodes: (show) ->
    {div, table, thead, tbody, tr, th} = DOM
    div
      className: 'table-responsive'
      table
        className: 'table-striped table-bordered table-condensed'
        thead null,
          tr null,
            th null, 'Season'
            th null, 'Episode'
            th null, 'Name'
            th null, 'Description'
        tbody null,
          if show.episodes.length == 0
            tr(null, td(colSpan: 6, 'No episodes found :/'))
          else
            show.episodes.map(@renderEpisode)

  renderEpisode: (episode) ->
    {tr, td, ActionLink} = DOM


    query = "#{episode.show.name} #{formatEpisodeQuery(episode.season_number, episode.episode_number)}"
    href = Location.for('/search', s: query)
    tr null,
      td null, episode.season_number
      td null, episode.seasonal_episode_number
      td null, ActionLink className: 'link', href: href, episode.name
      td null, episode.description

  renderFailed: (error) ->
    if error.xhr.status == 404
      DOM.h2(null, "No show found for: #{@props.query}")
    else
      DOM.span(null,"Error: #{error}")



formatEpisodeQuery = (season, episode) ->
  "S#{zeroPad(season)}E#{zeroPad(episode)}"

zeroPad = (number) ->
  number = parseInt(number.toString(), 10).toString()
  number = "0#{number}" if number.length < 2
  number

#= require ReactPromptMixin
#= require Show

component 'ShowPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  watchEpisode: (episode) ->
    App.downloadAndPlayMagnetLink(episode.magnet_link)

  render: ->
    DOM.div
      className: 'ShowPage'
      PromiseStateMachine
        promise: Show.find(@context.params.show_id)
        loaded: @renderShow

  renderShow: (show) ->
    console.log(show)
    {div, h1, h4, p, ActionLink, ShowArt} = DOM
    div null,
      ShowArt(show: show)
      h1 null, show.name
      @renderEpisodes(show)
      # show.episodes.map (episode, index) =>
      #   ActionLink
      #     className: 'link'
      #     onClick: @watchEpisode.bind(this, episode)
      #     key: index
      #     h4 null, episode.name



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


formatEpisodeQuery = (season, episode) ->
  "S#{zeroPad(season)}E#{zeroPad(episode)}"

zeroPad = (number) ->
  number = parseInt(number.toString(), 10).toString()
  number = "0#{number}" if number.length < 2
  number

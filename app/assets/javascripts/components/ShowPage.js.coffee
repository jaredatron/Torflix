#= require ReactPromptMixin
#= require Show

component 'ShowPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  watchEpisode: (episode) ->
    App.downloadAndPlayMagnetLink(episode.magnet_link)

  render: ->
    DOM.ShowPageLayout
      className: 'ShowPage'
      PromiseStateMachine
        promise: Show.find(@context.params.show_id)
        loaded: @renderShow

  renderShow: (show) ->
    console.info('Show:',show)
    {div, h1, h4, p, ActionLink, ShowArt} = DOM
    div null,
      ShowArt(show: show)
      h1 null, show.name
      @renderEpisodes(show)

  renderEpisodes: (show) ->
    DOM.div
      className: 'ShowPage-episodes'
      show.episodes.map(@renderEpisode)

  renderEpisode: (episode) ->
    {div, span, p, ActionLink} = DOM

    div
      key: episode.id
      className: 'ShowPage-episode'
      ActionLink
        href: Location.for('/search', s: episode.query())
        div
          className: 'link'
          span(null, episode.episodeId())
          span(null, ' ')
          span(null, episode.name)

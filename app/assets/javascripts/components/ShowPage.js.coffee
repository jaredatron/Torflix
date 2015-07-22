#= require ReactPromptMixin
#= require Show

component 'ShowPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  watchEpisode: (episode) ->
    App.putio.transfers.add(episode.link)
    Location.set Location.for('/waiting-for', link: episode.link)

  render: ->
    DOM.div
      className: 'ShowPage'
      PromiseStateMachine
        promise: Show.find(@context.params.show_id)
        loaded: @renderShow

  renderShow: (show) ->
    console.log(show)
    {div, h1, h4, p, ActionLink} = DOM
    div null,
      h1(null, show.title.replace(/^feed for /,''))
      show.episodes.map (episode, index) ->
        ActionLink
          onClick: @watchEpisode.bind(this, episode)
          key: index
          h4 null, episode.title


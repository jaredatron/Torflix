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
    {div, h1, h4, p, ActionLink, img} = DOM
    div null,
      if show.artwork_url
        img className: 'ShowPage-show-artwork', src: show.artwork_url

      h1 null, show.name
      show.episodes.map (episode, index) =>
        ActionLink
          className: 'link'
          onClick: @watchEpisode.bind(this, episode)
          key: index
          h4 null, episode.name


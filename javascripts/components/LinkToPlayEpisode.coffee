component 'LinkToPlayEpisode',

  propTypes:
    epsiode: React.PropTypes.instanceOf(Show.Episode).isRequired

  render: ->
    episode = @props.episode
    props = Object.assign({}, @props)
    props.href = "/shows/#{episode.show.id}/episodes/#{episode.id}"
    DOM.ActionLink(props)

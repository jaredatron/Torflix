#= require ReactPromptMixin
#= require Show

component 'ShowsPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.div
      className: 'ShowsPage'
      PromiseStateMachine
        promise: Show.all()
        loaded: @renderShows

  renderShows: (shows) ->
    console.log(shows)
    {div, ActionLink, img} = DOM
    div
      className: 'shows-list'
      shows.map (show, index) ->

        ActionLink
          key: index
          className: 'ShowsPage-show flex-column'
          href: "/shows/#{show.id}"
          if show.artwork_url
            img className: 'ShowsPage-show-artwork', src: show.artwork_url
          else
            div className: 'ShowsPage-show-name flex-grow', show.name


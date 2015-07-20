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
    {div, ActionLink} = DOM
    div
      className: 'shows-list'
      shows.map (show, index) ->
        ActionLink
          key: index
          href: "/shows/#{show.id}"
          show.name


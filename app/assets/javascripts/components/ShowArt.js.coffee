component 'ShowArt',

  propTypes:
    ShowArt: React.PropTypes.object.isRequired

  render: ->
    PromiseStateMachine
      promise: FindArtFor.show(@props.show.name)
      loading: @renderLoading
      loaded:  @renderLoaded

  renderLoading: ->
    @renderImage('/assets/spinner.gif')

  renderLoaded: (src) ->
    @renderImage(src)

  renderImage: (src) ->
    DOM.img
      className: Classnames('ShowArt', @props.className)
      src: src




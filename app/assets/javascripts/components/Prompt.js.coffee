component 'Prompt',

  propTypes:
    onRequestHide: React.PropTypes.func.isRequired

  render: ->
    DOM.Modal
      title:         @props.title
      animation:     @props.animation
      onRequestHide: @props.onRequestHide
      @props.children

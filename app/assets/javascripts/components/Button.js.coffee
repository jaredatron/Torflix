component 'Button',

  render: ->
    props = Object.assign({}, @props)
    props.className = Classnames('DeleteLink', @props.className)
    DOM.div(props)
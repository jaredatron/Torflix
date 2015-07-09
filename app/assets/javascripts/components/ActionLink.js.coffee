component 'ActionLink',

  onClick: (event) ->
    @props.onClick(event) if @props.onClick?
    # return if default is prevented
    event.preventDefault()
    if @props.href
      Location.set(@props.href, !!@props.default)

  render: ->
    props = Object.assign({}, @props)
    props.href = @props.href || ''
    props.onClick = @onClick
    DOM.a(props)

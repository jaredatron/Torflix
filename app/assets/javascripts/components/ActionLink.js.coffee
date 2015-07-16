component 'ActionLink',

  onClick: (event) ->
    return if event.metaKey || event.shiftKey || event.ctrlKey
    @props.onClick(event) if @props.onClick?
    return if event.defaultPrevented
    event.preventDefault()
    if @props.href
      Location.set(@props.href, !!@props.default)

  render: ->
    props = Object.assign({}, @props)
    props.href = @props.href || ''
    props.onClick = @onClick
    DOM.a(props)

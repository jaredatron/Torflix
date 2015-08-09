component 'ActionLink',

  onClick: (event) ->
    return if event.metaKey || event.shiftKey || event.ctrlKey
    if @props.onClick?
      try
        @props.onClick(event)
      catch error
        console.warn('Error caught by ActionLink')
        console.error(error)
        throw error
    return if event.defaultPrevented
    event.preventDefault()
    if @props.href
      Location.set(@props.href, !!@props.default)

  render: ->
    props = Object.assign({}, @props)
    props.href = @props.href || ''
    props.onClick = @onClick
    DOM.a(props)

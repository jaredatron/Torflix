component 'ExternalLink',

  propTypes:
    href: React.PropTypes.string.isRequired

  onClick: (event) ->
    event.preventDefault()

  render: ->
    props = Object.assign({}, @props)
    props.href = @props.href || ''
    props.target ||= '_blank'
    DOM.a(props)

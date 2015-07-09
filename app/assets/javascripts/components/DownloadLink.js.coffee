component 'DownloadLink',

  propTypes:
    href: React.PropTypes.string.isRequired

  render: ->
    props = Object.assign({}, @props)
    props.href = @props.href || ''
    props.download = true
    DOM.a(props)

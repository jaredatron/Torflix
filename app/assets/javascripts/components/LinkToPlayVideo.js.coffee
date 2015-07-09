component 'LinkToPlayVideo',

  propTypes:
    file_id: React.PropTypes.number.isRequired

  render: ->
    props = Object.assign({}, @props)
    props.href = "/video/#{@props.file_id}"
    DOM.ActionLink(props)

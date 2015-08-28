component 'LinkToShow',

  propTypes:
    show: React.PropTypes.object.isRequired

  render: ->
    props = Object.assign({}, @props)
    props.href = "/shows/#{@props.show.id}"
    DOM.ActionLink(props)

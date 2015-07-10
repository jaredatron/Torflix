#= require 'Classnames'

component 'Glyphicon',

  propTypes:
    glyph: React.PropTypes.string.isRequired

  render: ->
    props = Object.assign({}, @props)
    props.className = Classnames("glyphicon glyphicon-#{props.glyph}", props.className)
    props.glyph = undefined
    DOM.span(props, @props.children)

component = require 'reactatron/component'

module.exports = component 'StringInput',

  getValue: ->
    @refs.input.getDOMNode().value

  render: ->
    props = Object.assign({}, @props)
    props.ref = 'input'
    props.type = 'text'
    # props.className = Classnames('StringInput')
    DOM.div
      className: 'StringInput'
      DOM.input(props)
      if @props.glyph?
        DOM.Glyphicon glyph: @props.glyph

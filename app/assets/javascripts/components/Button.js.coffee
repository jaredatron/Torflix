component 'Button',

  propTypes:
    type: React.PropTypes.string

  getDefaultProps: ->
    type: 'default'

  render: ->
    props = Object.assign({}, @props)
    props.className = Classnames("btn btn-#{@props.type}", @props.className)
    DOM.div(props)
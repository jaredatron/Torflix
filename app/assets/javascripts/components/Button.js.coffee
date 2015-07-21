component 'Button',

  propTypes:
    type: React.PropTypes.string

  getDefaultProps: ->
    type: 'default'

  onClick: (event) ->
    event.preventDefault()
    @props.onClick(event) if @props.onClick

  onKeyUp: (event) ->
    @getDOMNode().click() if event.which == 32

  render: ->
    props = Object.assign({}, @props)
    props.href ||= ""
    props.className = Classnames("btn btn-#{@props.type}", @props.className)
    props.onClick = @onClick
    props.onKeyUp = @onKeyUp
    DOM.a(props)
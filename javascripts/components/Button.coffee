component = require 'reactatron/component'
{a} = require 'reactatron/DOM'

module.exports = component 'Button',

  propTypes:
    type: component.PropTypes.string

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
    a(props)

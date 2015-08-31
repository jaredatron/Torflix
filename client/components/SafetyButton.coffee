require 'stdlibjs/Array#last'

React = require 'react'
cloneWithProps = React.addons.cloneWithProps

component = require 'reactatron/component'

Columns = require 'reactatron/Columns'

module.exports = component 'SafetyButton',

  propTypes:
    default: component.PropTypes.any.isRequired
    abort:   component.PropTypes.any.isRequired
    confirm: component.PropTypes.any.isRequired

  getInitialState: ->
    confirming: false

  focus: ->
    return if @focusSetTimeout?
    @focusSetTimeout = setTimeout =>
      return unless @isMounted()
      delete @focusSetTimeout
      @getDOMNode().childNodes[0].focus()

  onClick: (event) ->
    @setState confirming: !@state.confirming
    @focus()

  render: ->
    props = @extendProps
      children:   undefined
      default:    undefined
      abort:      undefined
      confirm:    undefined
      onClick:    @onClick

    if @state.confirming
      props.extendStyle flexDirection: 'row-reverse'
      children = [@props.abort, @props.confirm]
    else
      children = [@props.default]

    Columns(props, children)

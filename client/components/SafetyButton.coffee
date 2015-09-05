require 'shouldhave/Array#last'

React = require 'reactatron/React'
cloneWithProps = React.addons.cloneWithProps

component = require 'reactatron/component'

Columns = require 'reactatron/Columns'

module.exports = component 'SafetyButton',

  propTypes:
    defaultButton: component.PropTypes.any.isRequired
    abortButton:   component.PropTypes.any.isRequired
    confirmButton: component.PropTypes.any.isRequired

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
      onClick: @onClick
      defaultButton:    undefined
      abortButton:      undefined
      confirmButton:    undefined

    if @state.confirming
      props.extendStyle flexDirection: 'row-reverse'
      children = [@props.abortButton, @props.confirmButton]
    else
      children = [@props.defaultButton]

    Columns(props, children)

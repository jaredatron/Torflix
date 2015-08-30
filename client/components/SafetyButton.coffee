require 'stdlibjs/Array#first'

React = require 'react'
cloneWithProps = React.addons.cloneWithProps

component = require 'reactatron/component'

Columns = require 'reactatron/Columns'

module.exports = component 'SafetyButton',

  propTypes:
    onClick: component.PropTypes.func.isRequired

  getInitialState: ->
    confirming: false

  confirm: ->
    return unless @isMounted()
    @setState confirming: true

  reset: ->
    return unless @isMounted()
    @setState confirming: false

  confirmAndFocus: ->
    @confirm()
    @focus()

  resetAndFocus: ->
    @reset()
    @focus()

  focus: ->
    return if @focusSetTimeout?
    @focusSetTimeout = setTimeout =>
      delete @focusSetTimeout
      (@refs.abort || @refs.main).getDOMNode().focus()

  scheduleReset: ->
    return if @resetTimeout
    @resetTimeout = setTimeout @reset

  unscheduleReset: ->
    clearTimeout(@resetTimeout) if @resetTimeout?
    delete @resetTimeout

  render: ->
    [button, confrimButton, abortButton] = @props.children

    if @state.confirming
      props = @extendProps
        onFocusOut: @scheduleReset
        onFocusIn: @unscheduleReset

      confrimButton = cloneWithProps confrimButton,
        ref: 'confirm'
        onClick: @props.onClick
        style:
          borderTopRightRadius: 0
          borderBottomRightRadius: 0

      abortButton = cloneWithProps abortButton,
        ref: 'abort'
        onClick: @resetAndFocus
        style:
          borderLeftWidth: 0
          borderTopLeftRadius: 0
          borderBottomLeftRadius: 0

      children = [abortButton, confrimButton]
    else
      props = @extendProps()

      button = cloneWithProps button,
        ref: 'main'
        onClick: @confirmAndFocus

      children = [button]

    Columns(props, children)

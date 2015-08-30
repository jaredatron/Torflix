require 'stdlibjs/Array#last'

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

  resetAndCallOnClick: (event) ->
    @reset()
    @props.onClick(event)

  focus: ->
    return if @focusSetTimeout?
    @focusSetTimeout = setTimeout =>
      return unless @isMounted()
      delete @focusSetTimeout
      # @getDOMNode().childNodes[0].focus()

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
        style:
          flexDirection: 'row-reverse'

       confrimButton = React.cloneElement confrimButton,
        key: 'confirm'
        onClick: @resetAndCallOnClick

       abortButton = React.cloneElement abortButton,
        key: 'main'
        onClick: @resetAndFocus

      children = [abortButton, confrimButton]
    else
      props = @extendProps()

      button = React.cloneElement button,
        key: 'main'
        onClick: @confirmAndFocus

      children = [button]

    delete props.children
    Columns(props, children)

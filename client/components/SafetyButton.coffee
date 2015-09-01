require 'stdlibjs/Array#last'

React = require 'react'
cloneWithProps = React.addons.cloneWithProps

component = require 'reactatron/component'

Columns = require 'reactatron/Columns'
withStyle = require 'reactatron/withStyle'

module.exports = component 'SafetyButton',

  propTypes:
    defaultButton: component.PropTypes.any.isRequired
    abortButton:   component.PropTypes.any.isRequired
    confirmButton: component.PropTypes.any.isRequired

  getInitialState: ->
    confirming: false

  # focus: ->
  #   return if @focusSetTimeout?
  #   @focusSetTimeout = setTimeout =>
  #     return unless @isMounted()
  #     delete @focusSetTimeout

  focus: ->
    console.log('@props.confirming', @props.confirming)
    [defaultButton, abortButton, confirmButton] = @getDOMNode().childNodes
    if @state.confirming
      console.log('focusing abort')
      abortButton.focus()
    else
      console.log('focusing default')
      defaultButton.focus()

  onClick: (event) ->
    @setState confirming: !@state.confirming
    # @focus()

  componentDidUpdate: (prevProps, prevStats) ->
    @focus() if @state.confirming != prevStats.confirming

  render: ->
    props = @extendProps
      defaultButton: undefined
      abortButton:   undefined
      confirmButton: undefined
      onClick:       @onClick

    if @state.confirming
      Columns props,
        hidden  @props.defaultButton
        visible @props.abortButton
        visible @props.confirmButton
    else
      Columns props,
        visible @props.defaultButton
        hidden  @props.abortButton
        hidden  @props.confirmButton


hidden = (element) ->
  withStyle display:'none', element

visible = (element) ->
  element



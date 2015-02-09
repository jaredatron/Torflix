React = require 'react'
component = require '../component'
ActionLink = require './ActionLink'
ConfirmationPrompt = require './ConfirmationPrompt'
Glyphicon = require 'react-bootstrap/Glyphicon'
Classnames = require '../Classnames'

module.exports = component 'DeleteLink',

  contextTypes:
    setPrompt:   React.PropTypes.func.isRequired
    clearPrompt: React.PropTypes.func.isRequired

  propTypes:
    question: React.PropTypes.func.isRequired
    onDelete: React.PropTypes.func.isRequired
    onAbort:  React.PropTypes.func

  onClick: ->
    @context.setPrompt =>
      ConfirmationPrompt
        abort:   'dont delete'
        confirm: 'delete'
        onAbort:   @onAbort
        onConfirm: @onConfirm
        @props.question()

  onAbort: ->
    @context.clearPrompt()
    @props.onAbort() if @props.onAbort?

  onConfirm: ->
    @context.clearPrompt()
    @props.onDelete()

  render: ->
    ActionLink
      onClick: @onClick
      className: Classnames('DeleteLink', @props.className)
      Glyphicon glyph: 'remove'

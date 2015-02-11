React     = require 'react'
component = require '../component'
Button    = require 'react-bootstrap/Button'
Prompt    = require './Prompt'

{div, span} = React.DOM

module.exports = component 'ConfirmationPrompt',

  propTypes:
    abort:     React.PropTypes.any.isRequired
    confirm:   React.PropTypes.any.isRequired
    onAbort:   React.PropTypes.func.isRequired
    onConfirm: React.PropTypes.func.isRequired
    autofocus: React.PropTypes.bool

  getDefaultProps: ->
    autofocus: true

  componentDidMount: ->
    @refs.abortButton.getDOMNode().focus() if @props.autofocus

  render: ->
    abortText   = @props.abort   || 'No'
    confirmText = @props.confirm || 'Yes'

    Prompt
      className: 'ConfirmationPrompt'
      onRequestHide: @props.onAbort

      div className: 'modal-body',
        @props.children,

      div className: 'modal-footer',
        Button
          ref: 'abortButton'
          bsStyle: 'default'
          onClick: @props.onAbort
          abortText
        Button
          ref: 'confirmButton'
          bsStyle: 'danger'
          onClick: @props.onConfirm
          confirmText

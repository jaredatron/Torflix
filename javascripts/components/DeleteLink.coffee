component = require 'reactatron/component'

module.exports = component 'DeleteLink',

  contextTypes:
    setPrompt:   component.PropTypes.func.isRequired
    clearPrompt: component.PropTypes.func.isRequired

  propTypes:
    question: component.PropTypes.func.isRequired
    onDelete: component.PropTypes.func.isRequired
    onAbort:  component.PropTypes.func

  onClick: ->
    @context.setPrompt =>
      DOM.ConfirmationPrompt
        abort:   'Don\'t Delete'
        confirm: 'Delete'
        onAbort:   @onAbort
        onConfirm: @onConfirm
        @props.question()
        autofocus: true

  onAbort: ->
    @context.clearPrompt()
    @props.onAbort() if @props.onAbort?

  onConfirm: ->
    @context.clearPrompt()
    @props.onDelete()

  render: ->
    DOM.ActionLink
      onClick: @onClick
      className: Classnames('DeleteLink', @props.className)
      DOM.Glyphicon glyph: 'remove'

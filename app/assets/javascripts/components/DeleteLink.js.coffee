component 'DeleteLink',

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

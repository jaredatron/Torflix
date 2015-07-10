component 'ConfirmationPrompt',

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

    {Prompt, div, Button} = DOM

    Prompt
      className: 'ConfirmationPrompt'
      onRequestHide: @props.onAbort

      div className: 'modal-body',
        @props.children,

      div className: 'modal-footer',
        Button
          ref: 'abortButton'
          onClick: @props.onAbort
          abortText
        Button
          ref: 'confirmButton'
          type: 'danger'
          onClick: @props.onConfirm
          confirmText

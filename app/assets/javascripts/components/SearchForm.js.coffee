component 'SearchForm',

  propTypes:
    onSearch: React.PropTypes.func.isRequired
    value:    React.PropTypes.string
    onChange: React.PropTypes.func

  getValue: ->
    @refs.input.getDOMNode().value

  onSubmit: (event) ->
    event.preventDefault()
    @props.onSearch @getValue()

  onChange: (event) ->
    @props.onChange @getValue()

  render: ->
    DOM.Form
      className: Classnames('SearchForm', @props.className)
      onSubmit: @onSubmit
      DOM.input
        ref: 'input'
        value: @props.value
        onChange: @onChange




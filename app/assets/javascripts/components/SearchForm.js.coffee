component 'SearchForm',

  propTypes:
    onSearch:     React.PropTypes.func.isRequired
    value:        React.PropTypes.string
    defaultValue: React.PropTypes.string

  getValue: ->
    @refs.input.getDOMNode().value

  onSubmit: (event) ->
    event.preventDefault()
    @props.onSearch @getValue()

  onChange: (event) ->
    if @props.onChange
      @props.onChange @getValue()

  render: ->
    DOM.Form
      className: Classnames('SearchForm', @props.className)
      onSubmit: @onSubmit
      DOM.input
        ref: 'input'
        defaultValue: @props.defaultValue
        value: @props.value
        onChange: @onChange
      DOM.Glyphicon glyph: 'search'




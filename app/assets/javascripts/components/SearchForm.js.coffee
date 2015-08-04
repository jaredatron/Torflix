component 'SearchForm',

  propTypes:
    onSearch:       React.PropTypes.func.isRequired
    value:          React.PropTypes.string
    defaultValue:   React.PropTypes.string
    collectionName: React.PropTypes.string

  getInitialState: ->
    query: valueFromParams()

  componentDidMount: ->
    Location.on('change', @updateQueryFromParams)

  componentWillUnmount: ->
    Location.off('change', @updateQueryFromParams)

  updateQueryFromParams: ->
    @setState query: valueFromParams()


  placeholder: ->
    if @props.collectionName
      "Search #{@props.collectionName}"
    else
      'Search…'

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
      DOM.StringInput
        ref: 'input'
        defaultValue: @props.defaultValue || valueFromParams()
        value: @props.value
        onChange: @onChange
        placeholder: @props.placeholder || @placeholder()
        autofocus: @props.autofocus
        glyph: 'search'





valueFromParams = ->
  Location.params.s || ''

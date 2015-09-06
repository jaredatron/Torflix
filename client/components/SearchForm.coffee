component  = require 'reactatron/component'
Form       = require 'reactatron/Form'
TextInput  = require 'reactatron/TextInput'
# Text       = require 'reactatron/Text'
# SublteText = require 'reactatron/SublteText'
# Columns    = require 'reactatron/Columns'
# Rows       = require 'reactatron/Rows'
# Link       = require 'reactatron/Link'
# Button     = require 'reactatron/Button'

Icon = require './Icon'


module.exports = component 'SearchForm',

  propTypes:
    onSearch:       component.PropTypes.func
    value:          component.PropTypes.string
    defaultValue:   component.PropTypes.string
    collectionName: component.PropTypes.string

  getInitialState: ->
    # query: valueFromParams()
    query: ''

  placeholder: ->
    if @props.collectionName
      "Search #{@props.collectionName}"
    else
      'Search…'

  getValue: ->
    @refs.input.getValue()

  onSubmit: (event) ->
    event.preventDefault()
    @props.onSearch @getValue()

  onChange: (event) ->
    if @props.onChange
      @props.onChange @getValue()

  render: ->
    Form
      style: @props.style
      className: @props.className
      onSubmit: @onSubmit
      TextInput
        ref: 'input'
        defaultValue: @props.defaultValue || ''
        value: @props.value
        onChange: @onChange
        placeholder: @props.placeholder || @placeholder()
        autofocus: @props.autofocus
        beforeInput:
          Icon glyph: 'search', style: marginRight: '0.5em', color: '#7B7B7B'
        style:
          width: '100%'





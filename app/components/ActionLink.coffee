React     = require 'react'
component = require '../component'
assign    = require('object-assign')

{a} = React.DOM

module.exports = component 'ActionLink',

  contextTypes:
    path: React.PropTypes.object.isRequired

  onClick: (event) ->
    @props.onClick(event) if @props.onClick?
    # return if default is prevented
    event.preventDefault()
    if @props.href
      @context.path.set(@props.href, !!@props.default)

  render: ->
    props = assign({}, @props)
    props.href = @props.href || ''
    props.onClick = @onClick
    a(props)

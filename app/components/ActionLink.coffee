React     = require 'react'
component = require '../component'
assign    = require('object-assign')

{a} = React.DOM


module.exports = component 'ActionLink',

  onClick: (event) ->
    event.preventDefault()
    @props.onClick(event) if @props.onClick?

  render: ->
    props = assign({
      href: ''
    }, @props, {
      onClick: @onClick
    })
    a(props)

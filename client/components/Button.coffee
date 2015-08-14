React = require 'react'
component = require 'reactatron/component'
{button} = require 'reactatron/DOM'

module.exports = component 'Button'
  render: ->
    props.className
    React.DOM.button(props)

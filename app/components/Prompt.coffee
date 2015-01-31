React      = require 'react'
component  = require '../component'
assign     = require 'object-assign'
Classnames = require '../Classnames'
Modal      = require 'react-bootstrap/Modal'

{div, span} = React.DOM

module.exports = component 'Prompt',

  propTypes:
    onRequestHide: React.PropTypes.func.isRequired

  render: ->
    Modal
      title:         @props.title
      animation:     @props.animation
      onRequestHide: @props.onRequestHide
      @props.children

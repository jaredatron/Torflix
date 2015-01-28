React      = require 'react'
assign     = require('object-assign')
component  = require '../component'
ActionLink = require './ActionLink'

{div, span, a} = React.DOM

module.exports = component 'LinkToVideoPlayerModal',

  contextTypes:
    path: React.PropTypes.object.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  render: ->
    props = assign({}, @props)
    props.href = @context.path.where(v: @props.file_id)
    ActionLink(props)

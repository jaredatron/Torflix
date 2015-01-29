React = require 'react'

module.exports =

  contextTypes:
    depth: React.PropTypes.number.isRequired

  childContextTypes:
    depth: React.PropTypes.number.isRequired

  getChildContext: ->
    depth: @context.depth + 1

  depth: ->
    @context.depth

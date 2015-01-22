React     = require 'react'
component = require './component'

{div} = React.DOM


module.exports = component 'TransfersList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  render: ->
    div(null, 'this is the transfers list')

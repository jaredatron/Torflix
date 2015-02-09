React      = require 'react'
component  = require '../component'
{span} = React.DOM

module.exports = component 'FileSize',

  contextTypes:
    size: React.PropTypes.number.isRequired

  render: ->
    size = @props.size || 0
    i = Math.floor( Math.log(size) / Math.log(1024) )
    number = Math.round( ( size / Math.pow(1024, i) ).toFixed(2) * 1 )
    unit = ['B', 'kB', 'MB', 'GB', 'TB'][i]
    span(null, "#{number} #{unit}")

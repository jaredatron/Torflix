React      = require 'react'
component  = require '../component'
{span} = React.DOM

module.exports = component 'FileSize',

  propTypes:
    size: React.PropTypes.number.isRequired

  render: ->
    size = @props.size

    if size > 0
      i = Math.floor( Math.log(size) / Math.log(1024) )
      number = Math.round( ( size / Math.pow(1024, i) ).toFixed(2) * 1 )
      unit = ['B', 'kB', 'MB', 'GB', 'TB'][i]
    else
      number = 0
      unit = 'B'

    span(className:'FileSize', "#{number} #{unit}")

component = require 'reactatron/component'
{span} = require 'reactatron/DOM'

module.exports = component 'FileSize',

  propTypes:
    size: component.PropTypes.number.isRequired

  render: ->
    size = @props.size

    if size > 0
      i = Math.floor( Math.log(size) / Math.log(1024) )
      number = Math.round( ( size / Math.pow(1024, i) ).toFixed(2) * 1 )
      unit = ['b', 'kb', 'mb', 'gb', 'tb'][i]
    else
      number = 0
      unit = 'B'

    span style: @props.style, "#{number}#{unit}"

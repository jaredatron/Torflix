component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'ColumnContainer',

  render: ->
    props = Object.assign({}, @props)
    style = props.style ||= {}
    style.display = 'flex'
    style.flexDirection = 'row'
    div(props)

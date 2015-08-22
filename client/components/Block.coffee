component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'Block',

  render: ->
    props = Object.assign({}, @props)
    style = props.style ||= {}
    style.display = 'flex'
    style.flexDirection = 'column'
    div(props)

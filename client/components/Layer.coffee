component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'Layer',

  render: ->
    props = Object.assign({}, @props)
    style = props.style ||= {}
    style.position = 'fixed'
    style.top = '0'
    style.left = '0'
    style.bottom = '0'
    style.right = '0'
    style.height = '100%'
    style.width = '100%'
    style.overflow = 'auto'
    div(props)

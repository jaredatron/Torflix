require 'stdlibjs/Object.clone'
component = require 'reactatron/component'
{a} = require 'reactatron/DOM'

module.exports = component 'Link',
  render: ->
    props = Object.clone(@props)
    props.className ||= ''
    props.className += ' Link'
    a(props)

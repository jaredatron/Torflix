component = require 'reactatron/component'
{div} = require 'reactatron/DOM'
Navbar = require './Navbar'
Layer = require './Layer'

module.exports = component 'Layout',

  render: ->

    Layer null,
      Navbar()
      @props.children

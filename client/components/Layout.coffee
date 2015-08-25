component = require 'reactatron/component'
{div} = require 'reactatron/DOM'
Layer = require 'reactatron/Layer'
Navbar = require './Navbar'

module.exports = component 'Layout',

  render: ->

    Layer {},
      Navbar {}
      @props.children

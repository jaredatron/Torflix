component = require 'reactatron/component'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  render: ->
    console.count('NotFoundPage render')
    Layout {},
      Block
        grow: 1
        style: {
          alignItems: 'center'
          justifyContent: 'center'
          flexWrap: 'nowrap'
        }
        Block {}, 'Page Not Found'

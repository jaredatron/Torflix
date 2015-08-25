component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'

module.exports = component 'ShowsPage',

  render: ->
    location = @get('location')
    Layout {},
      Rows grow: 1,
        Block {}, 'SHOWS PAGE'
        Block {}, 'path:',   JSON.stringify(location.path)
        Block {}, 'params:', JSON.stringify(location.params)


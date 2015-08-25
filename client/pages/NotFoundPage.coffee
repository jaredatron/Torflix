component = require 'reactatron/component'
Text = require 'reactatron/Text'
Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  render: ->
    console.count('NotFoundPage render')
    Layout {},
      Text {}, 'Page Not Found'

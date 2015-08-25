component = require 'reactatron/component'
Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  render: ->
    Layout {}, 'Page Not Found'

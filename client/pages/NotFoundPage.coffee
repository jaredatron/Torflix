component = require 'reactatron/component'
{div} = require 'reactatron/DOM'
Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  render: ->
    Layout null,
      div(null, 'Page not found')

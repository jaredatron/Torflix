component = require 'reactatron/component'
{div} = require 'reactatron/DOM'
Layout = require '../components/Layout'

module.exports = component 'ShowsPage',

  render: ->
    Layout null,
      div null, 'SHOWS PAGE'
      div null, 'path:',   JSON.stringify(location.path)
      div null, 'params:', JSON.stringify(location.params)
    # DOM.ShowPageLayout()


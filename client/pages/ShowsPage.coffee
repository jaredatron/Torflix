component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'ShowsPage',

  render: ->
    div null,
      div null, 'SHOWS PAGE'
      div null, 'path:',   JSON.stringify(@app.get('location').path)
      div null, 'params:', JSON.stringify(@app.get('location').params)
    # DOM.ShowPageLayout()


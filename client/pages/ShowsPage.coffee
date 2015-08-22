component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'ShowsPage',

  render: ->
    location = @app.get('location')
    div null,
      div null, 'SHOWS PAGE'
      div null, 'path:',   JSON.stringify(location.path)
      div null, 'params:', JSON.stringify(location.params)
    # DOM.ShowPageLayout()


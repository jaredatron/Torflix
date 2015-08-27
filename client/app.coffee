ReactatronApp = require('reactatron/App')
component = require('reactatron/component')
Putio = require('./Putio')
ResponsiveSizePlugin = require 'reactatron/ResponsiveSizePlugin'

app = new ReactatronApp

module.exports = app
app.putio = new Putio(app)

app.registerPlugin new ResponsiveSizePlugin
  window: global.window,
  widths: [480, 768, 992, 1200]

app.Component = component 'Router',

  render: ->


    {path, params} = @get('location')

    Component = switch
      when !@get('put_io_access_token')
        require('./pages/LoginPage')

      when path == '/shows'
        require('./pages/ShowsPage')

      when path == '/transfers'
        require('./pages/TransfersPage')

      else
        require('./pages/NotFoundPage')

    Component()


require('./actions/transferActions')(app)

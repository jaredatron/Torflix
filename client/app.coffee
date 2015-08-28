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


app.router = require './Router'

app.Component = component 'Router',

  render: ->

    route = if @get('put_io_access_token')
      @app.router.routeFor(@get('location'))
    else
      require('./pages/LoginPage')

    route.path
    route.params

    route.page()




require('./actions/transferActions')(app)

ReactatronApp = require('reactatron/App')
component = require('reactatron/component')
Putio = require('./Putio')
ResponsiveSizePlugin = require 'reactatron/ResponsiveSizePlugin'
RouterPlugin = require 'reactatron/RouterPlugin'

module.exports = app = new ReactatronApp



app.putio = new Putio(app)

app.registerPlugin new ResponsiveSizePlugin
  window: global.window,
  widths: [480, 768, 992, 1200]

app.registerPlugin new RouterPlugin ->
  @match '/',                       @redirectTo('/transfers')
  @match '/transfers',              require('./pages/TransfersPage')
  # @match '/transfers/:transfer_id', require('./pages/TransferPage')
  @match '/files',                  require('./pages/FilesPage')
  @match '/files/:file_id',         require('./pages/FilesPage')
  @match '/shows',                  require('./pages/ShowsPage')
  @match '/*path',                  require('./pages/NotFoundPage')


app.sub 'store:change:put_io_access_token', ->
  app.set loggedIn: app.get('put_io_access_token')?


app.MainComponent = component 'MainComponent', ->
  if @get('loggedIn')
    app.RouteComponent()
  else
    require('./pages/LoginPage')()






require('./actions/transfers')(app)
require('./actions/files')(app)

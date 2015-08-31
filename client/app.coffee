ReactatronApp = require('reactatron/App')
component = require('reactatron/component')
Putio = require('./Putio')
ResponsiveSizePlugin = require 'reactatron/ResponsiveSizePlugin'
RouterPlugin = require 'reactatron/RouterPlugin'


require('./FontAwesome').load()



module.exports = app = new ReactatronApp

app.registerPlugin new ResponsiveSizePlugin
  window: global.window,
  widths: [480, 768, 992, 1200]

app.registerPlugin new RouterPlugin ->
  @match '/',                       @redirectTo('/transfers')
  @match '/transfers',              require('./pages/TransfersPage')
  @match '/files',                  require('./pages/FilesPage')
  @match '/files/:fileId',          require('./pages/FilesPage')
  @match '/video/:fileId',          require('./pages/VideoPage')
  @match '/search',                 require('./pages/SearchPage')
  @match '/shows',                  require('./pages/ShowsPage')
  @match '/*path',                  require('./pages/NotFoundPage')


app.logout = ->
  app.set put_io_access_token: undefined

app.sub 'store:change:put_io_access_token', ->
  app.set loggedIn: app.get('put_io_access_token')?


app.MainComponent = component 'MainComponent',

  dataBindings: ->
    loggedIn: 'loggedIn'

  render: ->
    console.info('MainComponent render', @state)
    if @state.loggedIn
      app.RouteComponent()
    else
      require('./pages/LoginPage')()






require('./actions/putio')(app)
require('./actions/transfers')(app)
require('./actions/files')(app)

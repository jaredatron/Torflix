component    = require 'reactatron/component'
RouterPlugin = require 'reactatron/RouterPlugin'
RedirectPage = require('./pages/RedirectPage')

module.exports = (app) ->


  redirectTo = (path, params={}) ->
    component (props) ->
      location = app.locationFor(path, params)
      app.setLocation(location)
      RedirectPage path: path, params: params, location: location



  RouterPlugin app, ->
    @match '/',                       redirectTo('/transfers')
    @match '/bookmarks',              redirectTo('/')
    @match '/transfers',              require('./pages/TransfersPage')
    @match '/files',                  require('./pages/FilesPage')
    @match '/files/:fileId',          require('./pages/FilesPage')
    @match '/video/:fileId',          require('./pages/VideoPage')
    @match '/search',                 require('./pages/SearchPage')
    @match '/shows',                  require('./pages/ShowsPage')
    @match '/*path',                  require('./pages/NotFoundPage')



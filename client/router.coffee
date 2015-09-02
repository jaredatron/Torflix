RouterPlugin = require 'reactatron/RouterPlugin'

module.exports = (app) ->

  RouterPlugin app, ->
    @match '/',                       @redirectTo('/transfers')
    @match '/transfers',              require('./pages/TransfersPage')
    @match '/files',                  require('./pages/FilesPage')
    @match '/files/:fileId',          require('./pages/FilesPage')
    @match '/video/:fileId',          require('./pages/VideoPage')
    @match '/search',                 require('./pages/SearchPage')
    @match '/shows',                  require('./pages/ShowsPage')
    @match '/*path',                  require('./pages/NotFoundPage')

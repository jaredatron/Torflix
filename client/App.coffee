ReactatronApp = require('reactatron/App')

App = new ReactatronApp

App.router.map ->
  @match '/',               @redirectTo '/transfers'
  @match '/shows',          -> require('./pages/ShowsPage')
  @match '/shows/search',   -> require('./pages/ShowsSearchPage')
  @match '/shows/:show_id', -> require('./pages/ShowPage')
  @match '/transfers',      -> require('./pages/TransfersPage')
  @match '/files',          -> require('./pages/FilesPage')
  @match '/files/search',   -> require('./pages/FilesSearchPage')
  @match '/search',         -> require('./pages/TorrentsSearchPage')
  @match '/autoplay',       -> require('./pages/AutoplayPage')
  @match '/video/:file_id', -> require('./pages/VideoPage')
  @match '/*path',          -> require('./pages/PageNotFound')

module.exports = App
